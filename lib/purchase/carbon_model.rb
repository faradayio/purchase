require 'leap'
require 'timeframe'
require 'date'

module BrighterPlanet
  module Purchase
    module CarbonModel
      class MissingSectorForProductLineSector < Exception; end
      class MissingEmissionFactor < Exception; end
      class MissingSectorForIndustrySector < Exception; end

      def self.included(base)
        base.extend ::Leap::Subject
        base.extend FastTimestamp

        base.decide :emission, :with => :characteristics do
          committee :emission do
            quorum 'from emissions factor and adjusted cost', :needs => :sector_emissions do |characteristics|
              characteristics[:sector_emissions].values.inject(0) { |sum, emission| sum += emission }
            end
          end

          committee :sector_emissions do
            quorum 'from emissions factors and adjusted cost', :needs => [:emission_factors, :adjusted_cost] do |characteristics|
              characteristics[:emission_factors].inject({}) do |hsh, (io_code, share)|
                hsh[io_code] = share * characteristics[:adjusted_cost]
                hsh
              end
            end
          end

          committee :emission_factors do
            quorum 'from sector_shares', :needs => [:sector_shares] do |characteristics|
              characteristics[:sector_shares].inject({}) do |hsh, (io_code, data)|
                if data[:emission_factor].nil?
                  raise MissingEmissionFactor,
                    "Missing emission factor for sector #{io_code}"
                end
                hsh[io_code] = data[:emission_factor] * data[:share]
                hsh
              end
            end
            
            quorum 'default' do
              # FIXME TODO figure out a real fallback emission factor
              100
            end
          end
          
          committee :emission_factor do
            quorum 'from sector_shares', :needs => [:sector_shares] do |characteristics|
              characteristics[:sector_shares].inject(0) do |sum, (io_code, data)|
                if data[:emission_factor].nil?
                  raise MissingEmissionFactor,
                    "Missing emission factor for sector #{io_code}"
                end
                sum + data[:emission_factor] * data[:share]
              end
            end
            
            quorum 'default' do
              # FIXME TODO figure out a real fallback emission factor
              100
            end
          end
          
          committee :sector_shares do
            sector_shares_from_industry_shares = lambda do |characteristics|
              industry_shares = characteristics[:industry_shares]
              industry_sectors = industry_shares.map(&:industries_sectors).flatten
              industry_sectors.inject({}) do |hash, industry_sector|
                io_code = industry_sector.io_code
                unless ['420000','4A0000'].include?(io_code.to_s)
                  naics_code = industry_sector.naics_code
                  industry_share = industry_shares.find_by_naics_code naics_code
                  calculated_share = industry_share.ratio * industry_sector.ratio
                  sector = industry_sector.sector
                  if sector.nil?
                    raise MissingSectorForIndustrySector, 
                      "Missing a related sector for IndustrySector #{industry_sector.inspect}"
                  end
                  hash[io_code] = {
                    :share => calculated_share,
                    :emission_factor => sector.emission_factor
                  }
                end
                hash
              end
            end

            quorum 'from product line shares', :needs => [:industry_shares, :product_line_shares] do |characteristics|
              industry_sector_shares = sector_shares_from_industry_shares.
                call characteristics

              product_line_shares = characteristics[:product_line_shares]
              product_lines_sectors = ProductLinesSectors.find :all,
                :conditions => { :ps_code => product_line_shares.keys }
              product_sector_shares = product_lines_sectors.inject({}) do |hash, product_line_sector|
                io_code = product_line_sector.io_code
                ps_code = product_line_sector.ps_code
                product_line_share = product_line_shares[ps_code]

                share = product_line_sector.ratio * product_line_share
                sector = product_line_sector.sector
                if sector.nil?
                  raise MissingSectorForProductLineSector, 
                    "Missing a related sector for ProductLineSector #{product_line_sector.inspect}"
                end
                hash[io_code] = {
                  :share => share, 
                  :emission_factor => sector.emission_factor
                }
                hash
              end

              industry_sector_shares.merge product_sector_shares
            end
            
            quorum 'from product lines sectors', :needs => :product_lines_sectors do |characteristics|
              characteristics[:product_lines_sectors].inject({}) do |hash, product_line_sector|
                sector = product_line_sector.sector
                if sector.nil?
                  raise MissingSectorForProductLineSector, 
                    "Missing a related sector for ProductLineSector #{product_line_sector.inspect}"
                end
                hash[product_line_sector.io_code] = {
                  :share => product_line_sector.ratio, 
                  :emission_factor => sector.emission_factor
                }
                hash
              end
            end
          end

          committee :product_lines_sectors do
            quorum 'from ps_codes', :needs => :ps_codes do |characteristics|
              ProductLinesSectors.find :all, :conditions => { 
                :ps_code => characteristics[:ps_codes] }
            end
            quorum 'from sectors', :needs => :io_codes do |characteristics|
              sectors = Sector.find :all, :conditions => { :io_code => characteristics[:io_codes] }
              sectors.map(&:product_lines_sectors).flatten
            end
          end
          
          committee :product_line_shares do
            quorum 'from industry shares', :needs => :industry_shares do |characteristics|
              industry_shares = characteristics[:industry_shares]
              industries_product_lines = industry_shares.
                map(&:industries_product_lines).flatten
                  
              industries_product_lines.inject({}) do |hash, industry_product_line|
                ps_code = industry_product_line.ps_code
                naics_code = industry_product_line.naics_code
                industry_share = industry_shares.find_by_naics_code naics_code
                hash[ps_code] = 
                  industry_product_line.ratio * industry_share.ratio
                hash
              end
            end
          end
          
          committee :industry_shares do
            quorum 'from merchant category', :needs => :merchant_category do |characteristics|
              characteristics[:merchant_category].merchant_categories_industries
            end
            quorum 'from naics_codes', :needs => :naics_codes do |characteristics|
              industries = Industry.find :all, :conditions => { 
                :naics_code => characteristics[:naics_codes] }
              industries.map(&:merchant_categories_industries).flatten
            end
          end

          committee :merchant_category do
            quorum 'from merchant', :needs => [:merchant] do |characteristics|
              characteristics[:merchant].merchant_category
            end
          end
          
          committee :adjusted_cost do
            quorum 'from cost and date', :needs => [:cost, :date] do |characteristics|
              dollars_in_2002 characteristics[:cost], characteristics[:date]
            end
            
            quorum 'from purchase amount and date', :needs => [:purchase_amount, :date] do |characteristics|
              # FIXME TODO take out tax, then convert to 2002 US $ based on date and cost
              amount_without_tax = characteristics[:purchase_amount] * 0.9
              dollars_in_2002 amount_without_tax, characteristics[:date]
            end
          end

          committee :date do
            quorum 'default' do
              Date.today
            end
          end
        end
        # FIXME TODO make other committees to report emissions by gas, by io sector, etc.
      end

      # TODO: Come up with a way to fetch real CPI conversions
      def self.dollars_in_2002(amount, date)
        @cpi_lookup ||= { 2009 => 1.189, 2010 => 1.207, 2011 => 1.225, 2012 => 1.245, 2013 => 1.265 }

        date = date.is_a?(Date) ? date : Date.parse(date)
        conversion_factor = @cpi_lookup[date.year] || 1.207

        amount.to_f / conversion_factor
      end
    end
  end
end

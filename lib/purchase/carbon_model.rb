require 'leap'
require 'timeframe'

module BrighterPlanet
  module Purchase
    module CarbonModel
      class MissingSectorForProductLineSector < Exception; end
      class MissingEmissionFactor < Exception; end
      class MissingSectorForIndustrySector < Exception; end

      def self.included(base)
        base.extend ::Leap::Subject
        base.extend FastTimestamp

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

        base.decide :emission, :with => :characteristics do
          committee :emission do
            quorum 'from emissions factor and adjusted cost', :needs => [:emission_factor, :adjusted_cost] do |characteristics|
              #       lbs CO2e / 2002 US $              2002 US $
              characteristics[:emission_factor] * characteristics[:adjusted_cost]
            end
            
            quorum 'default' do
              raise "The purchase's default emission quorum should never be called"
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
            quorum 'from industry shares and product line shares', :needs => [:industry_shares, :product_line_shares] do |characteristics|
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
            
            # TODO Do we need this?
            quorum 'from industry shares', { :needs => [:industry_shares] },
              &sector_shares_from_industry_shares
            
            quorum 'default' do
              raise "We need a merchant, merchant category, industry, or product_line"
            end
          end
          
          committee :product_line_shares do
            quorum 'from industry shares', :needs => [:industry_shares] do |characteristics|
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
            quorum 'from merchant category', :needs => [:merchant_category] do |characteristics|
              characteristics[:merchant_category].merchant_categories_industries
            end
            quorum 'from industry', :needs => [:naics_codes] do |characteristics|
              industries = Industry.find :all, :conditions => { 
                :naics_code => characteristics[:naics_code] }
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
              # FIXME TODO convert cost to 2002 dollars based on date
              characteristics[:cost]
            end
            
            quorum 'from purchase amount and date', :needs => [:purchase_amount, :date] do |characteristics|
              # FIXME TODO take out tax, then convert to 2002 US $ based on date and cost
              characteristics[:purchase_amount] * 0.9
            end

            quorum 'default' do
              raise "We need either a cost or purchase amount"
            end
          end
        end

        # FIXME TODO make other committees to report emissions by gas, by io sector, etc.
        base.decide :sector_emissions, :with => :characteristics do
          committee :emission do
            quorum 'from emissions factors and adjusted cost', :needs => [:emission_factor, :adjusted_cost] do |characteristics|
              #       lbs CO2e / 2002 US $              2002 US $
              characteristics[:emission_factor] * characteristics[:adjusted_cost]
            end
            
            quorum 'default' do
              raise "The purchase's default emission quorum should never be called"
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
        end
      end

    end
  end
end

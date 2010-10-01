require 'leap'
require 'timeframe'
require 'date'
require 'matrix'

module BrighterPlanet
  module Purchase
    module CarbonModel
      def self.included(base)
        base.extend ::Leap::Subject
        base.extend FastTimestamp

        base.decide :emission, :with => :characteristics do
          committee :emission do
            quorum 'from impacts', :needs => :impacts do |characteristics|
              characteristics[:impacts].to_a.sum
            end
          end

          committee :impacts do
            quorum 'from economic flows and impact vectors', :needs => [:economic_flows, :impact_vectors] do |characteristics|
              characteristics[:impact_vectors] * characteristics[:economic_flows]
            end
          end

          committee :impact_vectors do
            quorum 'from database' do
              adapter = BrighterPlanet::Purchase.impact_vectors_adapter
              adapter.matrix
            end
          end

          committee :economic_flows do
            quorum 'from sector shares, a', :needs => [:sector_shares, :sector_direct_requirements] do |characteristics|
              y = characteristics[:sector_shares]
              leonteif_inverse = characteristics[:sector_direct_requirements]
              leonteif_inverse * y
            end
          end

          committee :sector_direct_requirements do
            quorum 'from database' do
              adapter = BrighterPlanet::Purchase.sector_direct_requirements_adapter
              adapter.matrix
            end
          end
          
          committee :sector_shares do
            quorum 'from industry sectors and product line shares', :needs => [:industry_sectors, :product_line_shares, :adjusted_cost] do |characteristics|
              industry_sector_shares = {}
              characteristics[:industry_sectors].each do |industry_sector|
                unless ['420000','4A0000'].include?(industry_sector.io_code)
                  industry_sector_shares[industry_sector.io_code] ||= 0
                  industry_sector_shares[industry_sector.io_code] += 
                    industry_sector.ratio * characteristics[:adjusted_cost]
                end
              end

              product_line_sector_shares = {}
              characteristics[:product_line_shares].each do |product_line_share|
                product_line_share.product_line_sectors.each do |product_line_sector|
                  io_code = product_line_sector.io_code
                  product_line_sector_shares[io_code] ||= 0
                  product_line_sector_shares[io_code] += 
                    product_line_sector.ratio * product_line_share.ratio * characteristics[:adjusted_cost]
                end
              end
              sector_shares = industry_sector_shares.merge product_line_sector_shares

              shares = BrighterPlanet::Purchase.key_map.map do |key|
                sector_shares[key] || 0
              end
              Vector[*shares]
            end

            quorum 'from industry sectors', :needs => [:industry_sectors, :adjusted_cost] do |characteristics|
              industry_sector_shares = {}
              characteristics[:industry_sectors].each do |industry_sector|
                unless ['420000','4A0000'].include?(industry_sector.io_code)
                  industry_sector_shares[industry_sector.io_code] ||= 0
                  industry_sector_shares[industry_sector.io_code] += 
                    industry_sector.ratio * characteristics[:adjusted_cost]
                end
              end
            
              shares = BrighterPlanet::Purchase.key_map.map do |key|
                industry_sector_shares[key] || 0
              end
              Vector[*shares]
            end
          end

          committee :industry_sectors do
            quorum 'from industry', :needs => :naics_code do |characteristics|
              industry_sectors = IndustrySector.
                find_all_by_naics_code characteristics[:naics_code]
              industry_sectors.map do |industry_sector|
                IndustrySectorShare.new industry_sector.io_code, industry_sector.ratio
              end
            end
            
            quorum 'from industry shares', :needs => :industry_shares do |characteristics|
              characteristics[:industry_shares].inject([]) do |list, industry_share|
                sectors = IndustrySector.
                  find_all_by_naics_code industry_share.naics_code
                sectors.each do |sector|
                  ratio = industry_share.ratio * sector.ratio
                  list << IndustrySectorShare.new(sector.io_code, ratio)
                end
                list
              end
            end
          end

          # only used for purchases from the wholesale and retail trade industries
          # product lines = the product lines sold by particular types of stores
          # ratios = the portion of the purchase amount that goes to each product line
          committee :product_line_shares do
            quorum 'from industry', :needs => :naics_code do |characteristics| IndustryProductLine.
                find_all_by_naics_code(characteristics[:naics_code]).
                map do |industry_product_line|
                  ProductLineShare.new industry_product_line.ps_code, 
                                       industry_product_line.ratio
                end
            end

            quorum 'from industry shares', :needs => :industry_shares do |characteristics|
              industry_shares = characteristics[:industry_shares]
              industry_shares.inject([]) do |list, industry_share|
                industry_product_lines = IndustryProductLine.
                  find_all_by_naics_code industry_share.naics_code
                industry_product_lines.each do |industry_product_line|
                  ratio = industry_product_line.ratio * industry_share.ratio
                  list << ProductLineShare.new(industry_product_line.ps_code, 
                                               ratio)
                end
                list
              end
            end
          end

          # industries = the industries needed to produce the purchased item
          # ratios = the portion of the purchase amount that goes to each industry
          committee :industry_ratios do
            quorum 'from non trade industry and industry product ratios', :needs => [:non_trade_industry_ratios, :industry_product_ratios] do |characteristics|
              combined_ratios = characteristics[:non_trade_industry_ratios].
                merge characteristics[:industry_product_ratios]
            end
          end

          committee :industry_product_ratios do
            quorum 'from product line industry product ratios', :needs => :product_line_industry_product_ratios do |characteristics|
              characteristics[:product_line_industry_product_ratios].inject({}) do |new_ratios, (naics_product_code, ratio)|
                IndustryProduct.where(:naics_product_code => naics_product_code).each do |industry_product|
                  new_ratios[industry_product.naics_code] = ratio
                end
                new_ratios
              end
            end
          end

          committee :product_line_industry_product_ratios do
            quorum 'from product line ratios', :needs => :product_line_ratios do |characteristics|
              characteristics[:product_line_ratios].inject({}) do |new_ratios, (ps_code, ratio)|
                ProductLineIndustryProduct.where(:ps_code => ps_code).each do |plip|
                  new_ratio = ratio * plip.ratio
                  new_ratios[plip.naics_product_code] = new_ratio
                end
                new_ratios
              end
            end
          end

          committee :product_line_ratios do
            quorum 'from trade industry ratios', :needs => :trade_industry_ratios do |characteristics|
              characteristics[:trade_industry_ratios].inject({}) do |new_ratios, (naics, ratio)|
                IndustryProductLine.where(:naics_code => naics).each do |industry_product_line|
                  new_ratio = ratio * industry_product_line.ratio
                  new_ratios[industry_product_line.ps_code] = new_ratio
                end
                new_ratios
              end
            end
          end

          committee :non_trade_industry_ratios do
            quorum 'from merchant category industries', :needs => :merchant_category_industries do |characteristics|
              characteristics[:merchant_category_industries].inject({}) do |hash, merchant_category_industry|
                unless Industry.trade_industry?(merchant_category_industry.naics_code)
                  hash[merchant_category_industry.naics_code] = merchant_category_industry.ratio
                end
                hash
              end
            end

            quorum 'from naics code', :needs => :naics_code do |characteristics|
              if Industry.trade_industry?(characteristics[:naics_code])
                {}
              else
                { characteristics[:naics_code].to_s => 1 }
              end
            end
          end

          committee :trade_industry_ratios do
            quorum 'from merchant category industries', :needs => :merchant_category_industries do |characteristics|
              characteristics[:merchant_category_industries].inject({}) do |hash, merchant_category_industry|
                if Industry.trade_industry?(merchant_category_industry.naics_code)
                  hash[merchant_category_industry.naics_code] = merchant_category_industry.ratio
                end
                hash
              end
            end

            quorum 'from naics code', :needs => :naics_code do |characteristics|
              if Industry.trade_industry?(characteristics[:naics_code])
                { characteristics[:naics_code].to_s => 1 }
              else
                {}
              end
            end
          end

          # a dictionary to go from merchant categories to industries
          committee :merchant_category_industries do
            quorum 'from merchant category', :needs => :merchant_category do |characteristics|
              characteristics[:merchant_category].merchant_category_industries
            end
            quorum 'from industry', :needs => :naics_code do |characteristics|
              MerchantCategoryIndustry.find_all_by_naics_code characteristics[:naics_code]
            end
          end

          committee :merchant_category do
            quorum 'from merchant', :needs => [:merchant] do |characteristics|
              characteristics[:merchant].merchant_category
            end
            
            quorum 'default' do
              # FIXME TODO figure out a better merchant category or fallback sectors to use
              MerchantCategory.find_by_mcc 5111
            end
          end
          
          committee :adjusted_cost do
            quorum 'from cost and date', :needs => [:cost, :date] do |characteristics|
              # TODO: Come up with a way to fetch real CPI conversions
              @cpi_lookup ||= { 
                2009 => 1.189, 2010 => 1.207, 2011 => 1.225, 2012 => 1.245, 
                2013 => 1.265 }

              date = characteristics[:date]
              date = date.is_a?(String) ? Date.parse(date) : date
              conversion_factor = @cpi_lookup[date.year] || 1.207

              characteristics[:cost].to_f / conversion_factor
            end
          end
            
          committee :cost do
            quorum 'from purchase amount and tax', :needs => [:purchase_amount, :tax] do |characteristics|
              characteristics[:purchase_amount].to_f - characteristics[:tax].to_f
            end
            
            quorum 'from purchase amount', :needs => :purchase_amount do |characteristics|
              # tax based on http://www.thestc.com/STrates.stm weighted by US Census 2010 projected state population (exclude samoa, guam, pr)
              characteristics[:purchase_amount].to_f / 1.0711
            end
            
            quorum 'from default' do
              # FIXME TODO research real average purchase amount
              100
            end
          end

          committee :date do
            quorum 'default' do
              Date.today
            end
          end
        end
      end

      class IndustrySectorShare < Struct.new(:io_code, :ratio); end
    end
  end
end

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
              characteristics[:impacts].sum
            end
          end

          committee :impacts do
            quorum 'from economic flows and impact vectors', :needs => [:economic_flows, :impact_vectors] do |characteristics|
              result = characteristics[:impact_vectors] * characteristics[:economic_flows]
              puts result.inspect
              result
            end
          end

          committee :impact_vectors do
            quorum 'from database' do
              adapter = BrighterPlanet::Purchase.impact_vectors_adapter
              Matrix[*adapter.data]
            end
          end

          committee :economic_flows do
            quorum 'from sector shares, a', :needs => [:sector_shares, :adjusted_cost, :sector_direct_requirements] do |characteristics|
              y = characteristics[:sector_shares]
              i = Matrix.identity(y.column_size)
              a = characteristics[:sector_direct_requirements]
              economic_flows = y * (i - a).inverse
              economic_flows.row(0)
            end
          end

          committee :sector_direct_requirements do
            quorum 'from database' do
              adapter = BrighterPlanet::Purchase.sector_direct_requirements_adapter
              Matrix[*adapter.data]
            end
          end
          
          committee :sector_shares do
            quorum 'from industry shares and product line shares', :needs => [:industries_sectors, :product_line_shares] do |characteristics|
              industry_sector_shares = {}
              characteristics[:industries_sectors].each do |industry_sector|
                unless ['420000','4A0000'].include?(industry_sector.io_code)
                  sector = Sector.find_by_io_code industry_sector.io_code
                  industry_sector_shares[sector.io_code] ||= 0
                  industry_sector_shares[sector.io_code] += 
                    industry_sector.ratio * sector.emission_factor
                end
              end

              product_line_sector_shares = {}
              characteristics[:product_line_shares].each do |product_line_share|
                product_line_share.product_lines_sectors.each do |product_line_sector|
                  sector = product_line_sector.sector
                  product_line_sector_shares[sector.io_code] ||= 0
                  product_line_sector_shares[sector.io_code] += 
                    product_line_sector.ratio * product_line_share.ratio * sector.emission_factor
                end
              end
              sector_shares = industry_sector_shares.merge product_line_sector_shares

              shares = BrighterPlanet::Purchase::KEY_MAP.map do |key|
                sector_shares[key] || 0
              end
              Vector[*shares]
            end

            quorum 'from industry', :needs => :naics_code do |characteristics|
              industries_sectors = IndustriesSectors.
                find_all_by_naics_code characteristics[:naics_code]
              industry_sector_shares = {}
              industries_sectors.each do |industry_sector|
                unless ['420000','4A0000'].include?(industry_sector.io_code)
                  sector = Sector.find_by_io_code industry_sector.io_code
                  industry_sector_shares[sector.io_code] ||= 0
                  industry_sector_shares[sector.io_code] += 
                    industry_sector.ratio * sector.emission_factor
                end
              end
              SectorShareVector.create industry_sector_shares
            end
          end

          committee :industries_sectors do
            quorum 'from industry shares', :needs => :industry_shares do |characteristics|
              characteristics[:industry_shares].inject([]) do |list, industry_share|
                sectors = IndustriesSectors.
                  find_all_by_naics_code industry_share.naics_code
                sectors.each do |sector|
                  ratio = industry_share.ratio * sector.ratio
                  list << IndustrySectorShare.new(sector.io_code, ratio)
                end
                list
              end
            end

            quorum 'from industry', :needs => :naics_code do |characteristics|
              industries_sectors = IndustriesSectors.
                find_all_by_naics_code characteristics[:naics_code]
              industries_sectors.map do |industry_sector|
                IndustrySectorShare.new industry_sector.io_code, industry_sector.ratio
              end
            end
          end

          committee :product_line_shares do
            quorum 'from industry shares', :needs => :industry_shares do |characteristics|
              industry_shares = characteristics[:industry_shares]
              industry_shares.inject([]) do |list, industry_share|
                industries_product_lines = IndustriesProductLines.
                  find_all_by_naics_code industry_share.naics_code
                industries_product_lines.each do |industry_product_line|
                  ratio = industry_product_line.ratio * industry_share.ratio
                  list << ProductLineShare.new(industry_product_line.ps_code, 
                                               ratio)
                end
                list
              end
            end

            quorum 'from industry', :needs => :naics_code do |characteristics|
              IndustriesProductLines.
                find_all_by_naics_code(characteristics[:naics_code]).
                map do |industry_product_line|
                  ProductLineShare.new industry_product_line.ps_code, 
                                       industry_product_line.ratio
                end
            end
          end
          
          committee :industry_shares do
            quorum 'from merchant_categories_industries', :needs => :merchant_categories_industries do |characteristics|
              characteristics[:merchant_categories_industries].map do |mci|
                IndustryShare.new mci.naics_code, mci.ratio
              end
            end
          end

          committee :merchant_categories_industries do
            quorum 'from merchant category', :needs => :merchant_category do |characteristics|
              characteristics[:merchant_category].merchant_categories_industries
            end
          end

          committee :merchant_category do
            quorum 'from merchant', :needs => [:merchant] do |characteristics|
              characteristics[:merchant].merchant_category
            end
            
            quorum 'default' do
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
              # FIXME TODO take out tax
              characteristics[:purchase_amount].to_f * 0.9
            end
            
            quorum 'default' do
              100
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

      class IndustryShare < Struct.new(:naics_code, :ratio); end
      class IndustrySectorShare < Struct.new(:io_code, :ratio); end

      class ProductLineShare
        attr_accessor :ps_code, :ratio

        def initialize(ps_code, ratio)
          self.ps_code = ps_code
          self.ratio = ratio
        end

        def product_lines_sectors
          ProductLinesSectors.find_all_by_ps_code ps_code
        end
      end

      class SectorShare < Struct.new(:io_code, :share, :emission_factor)
        def initialize(sector, share)
          self.io_code = sector.io_code
          self.share = share
          self.emission_factor = sector.emission_factor
        end
      end

      class EmissionFactor < Struct.new(:io_code, :factor); end
    end

    KEY_MAP = (1..26).to_a.map(&:to_s) + %w{44100 44101 44102 44103 44104 44105}
  end
end

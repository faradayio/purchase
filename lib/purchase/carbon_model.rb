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
              characteristics[:sector_emissions].sum
            end
          end

          committee :sector_emissions do
            quorum 'from emissions factors and adjusted cost', :needs => [:emission_factors, :adjusted_cost] do |characteristics|
              characteristics[:emission_factors].map do |emission_factor|
                emission_factor.factor * characteristics[:adjusted_cost]
              end
            end
          end

          committee :emission_factors do
            quorum 'from sector shares', :needs => [:sector_shares] do |characteristics|
              characteristics[:sector_shares].inject([]) do |list, sector_share|
                factor = sector_share.emission_factor * sector_share.share
                list << EmissionFactor.new(sector_share.io_code, factor)
              end
            end
            
            # FIXME TODO figure out if we really want a fallback and get a real one
            quorum 'default' do
              [EmissionFactor.new(0, 1)]
            end
          end
          
          committee :sector_shares do
            quorum 'from industry shares and product line shares', :needs => [:industry_shares, :product_line_shares] do |characteristics|
              industry_shares = characteristics[:industry_shares]
              industry_sector_shares = industry_shares.inject([]) do |list, industry_share|
                industry_share.industries_sectors.each do |industry_sector|
                  io_code = industry_sector.io_code
                  unless ['420000','4A0000'].include?(io_code.to_s)
                    calculated_share = industry_share.ratio * industry_sector.ratio
                    sector = industry_sector.sector
                    list << SectorShare.new(sector, calculated_share)
                  end
                end
                list
              end

              product_line_shares = characteristics[:product_line_shares]
              product_sector_shares = product_line_shares.inject([]) do |list, product_line_share|
                product_line_share.product_lines_sectors.each do |product_line_sector|
                  calculated_share = product_line_sector.ratio * product_line_share.ratio
                  sector = product_line_sector.sector
                  list << SectorShare.new(sector, calculated_share)
                end
                list
              end

              industry_sector_shares + product_sector_shares
            end
          end

          committee :product_line_shares do
            quorum 'from industry shares', :needs => :industry_shares do |characteristics|
              industry_shares = characteristics[:industry_shares]
              industry_shares.inject([]) do |list, industry_share|
                industry_share.industries_product_lines.each do |industry_product_line|
                  ratio = industry_product_line.ratio * industry_share.ratio
                  list << ProductLineShare.new(industry_product_line.ps_code, 
                                               ratio)
                end
                list
              end
            end
          end
          
          committee :industry_shares do
            quorum 'from merchant category', :needs => :merchant_category do |characteristics|
              IndustryShare.find_all_by_merchant_category characteristics[:merchant_category]
            end
            quorum 'from industry', :needs => :naics_code do |characteristics|
              IndustryShare.find_all_by_naics_code characteristics[:naics_code]
            end
          end

          committee :merchant_category do
            quorum 'from merchant', :needs => [:merchant] do |characteristics|
              characteristics[:merchant].merchant_category
            end
          end
          
          committee :adjusted_cost do
            quorum 'from cost and date', :needs => [:cost, :date] do |characteristics|
              # TODO: Come up with a way to fetch real CPI conversions
              @cpi_lookup ||= { 
                2009 => 1.189, 2010 => 1.207, 2011 => 1.225, 2012 => 1.245, 
                2013 => 1.265 }

              date = date.is_a?(Date) ? date : Date.parse(date)
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
  end
end

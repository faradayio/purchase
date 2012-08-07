# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

require 'leap'
require 'timeframe'
require 'date'
require 'matrix'

require 'earth/industry/industry_product'
require 'earth/industry/industry_product_line'
require 'earth/industry/industry_sector'
require 'earth/industry/product_line_industry_product'

module BrighterPlanet
  module Purchase
    module ImpactModel
      def self.included(base)
        base.extend ::Leap::Subject
        
        base.decide :impact, :with => :characteristics do
          committee :carbon do
            quorum 'from impacts', :needs => :impacts do |characteristics|
              characteristics[:impacts].to_a.sum
            end
          end
          
          committee :impacts do
            quorum 'from economic flows and impact vectors', :needs => [:economic_flows, :impact_vectors] do |characteristics|
              # subverting charisma
              characteristics[:impact_vectors].value * characteristics[:economic_flows].value
            end
          end
          
          committee :direct_emissions do
            quorum 'from sector shares and impact vectors', :needs => [:sector_shares, :impact_vectors] do |characteristics|
              (characteristics[:impact_vectors].value * characteristics[:sector_shares].value).to_a.sum
            end
          end
          
          committee :impact_vectors do
            quorum 'from database' do
              ::BrighterPlanet::Purchase.impact_vectors_adapter.matrix
            end
          end
          
          committee :economic_flows do
            quorum 'from sector shares', :needs => [:sector_shares, :sector_direct_requirements] do |characteristics|
              # subverting charisma
              characteristics[:sector_direct_requirements].value * characteristics[:sector_shares].value
            end
          end
          
          committee :sector_direct_requirements do
            quorum 'from database' do
              BrighterPlanet::Purchase.sector_direct_requirements_adapter.matrix
            end
          end
          
          committee :sector_shares do
            quorum 'from industry sector shares', :needs => :industry_sector_shares do |characteristics|
              shares = BrighterPlanet::Purchase.key_map.map do |key|
                characteristics[:industry_sector_shares][key] || 0
              end
              ::Vector[*shares]
            end
          end
          
          committee :industry_sector_shares do
            quorum 'from industry sector ratios', :needs => [:industry_sector_ratios, :adjusted_cost] do |characteristics|
              characteristics[:industry_sector_ratios].inject({}) do |new_ratios, (io_code, ratio)|
                new_ratios[io_code] ||= 0
                new_ratios[io_code] += ratio * characteristics[:adjusted_cost]
                new_ratios
              end
            end
          end
          
          # Convert spend in industries to spend in input-output sectors
          committee :industry_sector_ratios do
            quorum 'from industry ratios', :needs => :industry_ratios do |characteristics|
              naics_codes = characteristics[:industry_ratios].keys
              industry_sectors = IndustrySector.where(:naics_code => naics_codes)
              characteristics[:industry_ratios].inject({}) do |new_ratios, (naics_code, ratio)|
                industry_sectors.
                  find_all { |i| i.naics_code == naics_code }.
                  each do |industry_sector|
                  new_ratios[industry_sector.io_code] ||= 0
                  new_ratio = ratio * industry_sector.ratio
                  new_ratios[industry_sector.io_code] += new_ratio
                end
                new_ratios
              end
            end
          end
          
          # industries = the industries needed to produce the purchased item
          # ratios = the portion of the purchase amount that goes to each industry
          committee :industry_ratios do
            quorum 'from non trade industry and industry product ratios', :needs => [:non_trade_industry_ratios, :industry_product_ratios] do |characteristics|
              combined_ratios = characteristics[:non_trade_industry_ratios].
                merge(characteristics[:industry_product_ratios]) do |key, non_trade, ip_ratio|
                  non_trade + ip_ratio
                end
            end
          end
          
          # Convert any spend on products produced by product/service industries to spend in the relevant product/service industries
          committee :industry_product_ratios do
            quorum 'from product line industry product ratios', :needs => :product_line_industry_product_ratios do |characteristics|
              naics_product_codes = characteristics[:product_line_industry_product_ratios].keys
              industry_products = IndustryProduct.where(:naics_product_code => naics_product_codes)
              characteristics[:product_line_industry_product_ratios].inject({}) do |new_ratios, (naics_product_code, ratio)|
                industry_products.
                  find_all { |i| i.naics_product_code == naics_product_code }.
                  each do |industry_product|
                  new_ratios[industry_product.naics_code] ||= 0
                  new_ratios[industry_product.naics_code] += ratio
                end
                new_ratios
              end
            end
          end
          
          # Convert any spend on products sold by trade industries to spend on products produced by product/service industries
          committee :product_line_industry_product_ratios do
            quorum 'from product line ratios', :needs => :product_line_ratios do |characteristics|
              ps_codes = characteristics[:product_line_ratios].keys
              plips = ProductLineIndustryProduct.where(:ps_code => ps_codes)
              characteristics[:product_line_ratios].inject({}) do |new_ratios, (ps_code, ratio)|
                plips.find_all { |p| p.ps_code == ps_code }.each do |plip|
                  new_ratios[plip.naics_product_code] ||= 0
                  new_ratio = ratio * plip.ratio
                  new_ratios[plip.naics_product_code] += new_ratio
                end
                new_ratios
              end
            end
          end
          
          # Convert any spend in trade industries to spend on the products sold by those industries
          committee :product_line_ratios do
            quorum 'from trade industry ratios', :needs => :trade_industry_ratios do |characteristics|
              naics_codes = characteristics[:trade_industry_ratios].keys
              industry_product_lines = IndustryProductLine.where(:naics_code => naics_codes)
              characteristics[:trade_industry_ratios].inject({}) do |new_ratios, (naics, ratio)|
                industry_product_lines.
                  find_all { |i| i.naics_code == naics}.
                  each do |industry_product_line|
                  new_ratios[industry_product_line.ps_code] ||= 0
                  new_ratio = ratio * industry_product_line.ratio
                  new_ratios[industry_product_line.ps_code] += new_ratio
                end
                new_ratios
              end
            end
          end
          
          # The percent of cost spent in industries that produce goods or services
          committee :non_trade_industry_ratios do
            quorum 'from industry', :needs => :industry do |characteristics|
              if characteristics[:industry].trade_industry?
                {}
              else
                { characteristics[:industry].naics_code.to_s => 1 }
              end
            end
            
            quorum 'from merchant category industries', :needs => :merchant_category_industries do |characteristics|
              characteristics[:merchant_category_industries].
                reject { |mci| mci.industry.trade_industry? }.inject({}) do |ntir, merchant_category_industry|
                  ntir[merchant_category_industry.naics_code] ||= 0
                  ntir[merchant_category_industry.naics_code] += merchant_category_industry.ratio
                  ntir
              end
            end
            
            quorum 'from sic industry', :needs => :sic_industry do |characteristics|
              if (naics_2002s = characteristics[:sic_industry].naics_2002).any?
                industries = naics_2002s.map(&:industry)
                industries.reject{ |i| i.trade_industry? }.inject({}) do |ntir, industry|
                  ntir[industry.naics_code] ||= 0
                  ntir[industry.naics_code] += 1.0 / industries.count
                  ntir
                end
              else
                nil # return nil if we can't map the SIC industry to any Industries so that we use the default quorum
              end
            end
            
            # NAICS 339991 chosen because it's emissions intensity is close to the average of the entire U.S. economy
            # (calculated by multiplying each sector's emissions intensity by it's share of total 2002 value)
            quorum 'default' do
              { '339991' => 1 }
            end
          end
          
          # The percent of cost spent in trade industries (which therefore needs to get converted to products)
          committee :trade_industry_ratios do
            quorum 'from industry', :needs => :industry do |characteristics|
              if characteristics[:industry].trade_industry?
                { characteristics[:industry].naics_code.to_s => 1 }
              else
                {}
              end
            end
            
            quorum 'from merchant category industries', :needs => :merchant_category_industries do |characteristics|
              characteristics[:merchant_category_industries].
                select { |mci| mci.industry.trade_industry? }.inject({}) do |tir, merchant_category_industry|
                  tir[merchant_category_industry.naics_code] ||= 0
                  tir[merchant_category_industry.naics_code] += merchant_category_industry.ratio
                  tir
              end
            end
            
            quorum 'from sic industry', :needs => :sic_industry do |characteristics|
              # This will return {} if there are no trade industry ratios but that's ok b/c it's the same as the default
              if (naics_2002s = characteristics[:sic_industry].naics_2002).any?
                industries = naics_2002s.map(&:industry)
                industries.select{ |i| i.trade_industry? }.inject({}) do |tir, industry|
                  tir[industry.naics_code] ||= 0
                  tir[industry.naics_code] += 1.0 / industries.count
                  tir
                end
              end
            end
            
            quorum 'default' do
              {}
            end
          end
          
          # a dictionary to go from merchant categories to industries
          committee :merchant_category_industries do
            quorum 'from merchant category', :needs => :merchant_category do |characteristics|
              characteristics[:merchant_category].merchant_category_industries
            end
          end
          
          committee :merchant_category do
            quorum 'from merchant', :needs => [:merchant] do |characteristics|
              characteristics[:merchant].merchant_category
            end
          end
          
          # The purchase amount in 2002 dollars
          committee :adjusted_cost do
            quorum 'from cost and date', :needs => [:cost, :date] do |characteristics|
              # FIXME TODO: Import CPI conversions
              @cpi_lookup ||= { 
                2009 => 1.189, 2010 => 1.207, 2011 => 1.225, 2012 => 1.245, 
                2013 => 1.265 }
                
              date = characteristics[:date]
              date = date.is_a?(String) ? Date.parse(date) : date
              conversion_factor = @cpi_lookup[date.year] || 1.207
              
              characteristics[:cost].to_f / conversion_factor
            end
            
            # This is the average federal government purchase card transaction in 2003, converted to 2002 dollars, with tax taken out
            # See http://www.sba.gov/advo/research/rs226tot.pdf
            quorum 'default' do
              517
            end
          end
          
          # The purchase amount, less taxes
          committee :cost do
            quorum 'from purchase amount and tax', :needs => [:purchase_amount, :tax] do |characteristics|
              characteristics[:purchase_amount].to_f - characteristics[:tax].to_f
            end
            
            # Based on http://www.thestc.com/STrates.stm weighted by US Census 2010 projected state population (exclude samoa, guam, pr)
            quorum 'from purchase amount', :needs => :purchase_amount do |characteristics|
              characteristics[:purchase_amount].to_f / 1.0711
            end
          end
          
          committee :date do
            quorum 'default' do
              Date.today
            end
          end
        end
      end
    end
  end
end

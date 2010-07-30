require 'leap'
require 'timeframe'

module BrighterPlanet
  module Purchase
    module CarbonModel
      def self.included(base)
        base.extend ::Leap::Subject
        base.extend FastTimestamp
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
              sum(
                characteristics[:sector_shares].each do |sector_share|
                  sector_share.emission_factor * sector_share.share
                end
              )
            end
            
            quorum 'default' do
              # FIXME TODO figure out a real fallback emission factor
              100
            end
          end
          
          committee :sector_shares do
            quorum 'from industry shares and product line shares', :needs => [:industry_shares, :product_line_shares] do |characteristics|
              industry_shares = characteristics[:industry_shares].collect do |industry_share|
                # go to the industries_sectors table
                # look up all the rows where naics_code = industry_share.naics_code and io_code is not 420000 and io_code is not 4A0000
                # take io_code and (ratio * industry_share.share) for those rows
              end
              product_line_shares = characteristics[:product_line_shares].collect do |product_line_share|
                # go to the product_lines_sectors table
                # look up all the rows where ps_code = product_line_share.ps_code
                # take io_code and (ratio * product_line_share.share) for those rows
              end
              industry_shares + product_line_shares
            end
            
            quorum 'from industry shares', :needs => [:industry_shares] do |characteristics|
              characteristics[:industry_shares].collect do |industry_share|
                # go to the industries_sectors table
                # look up all the rows where naics_code = industry_share.naics_code and io_code is not 420000 and io_code is not 4A0000
                # take io_code and (ratio * industry_share.share) for those rows
              end
            end
            
            quorum 'from product line shares', :needs => [:product_line_shares] do |characteristics|
              characteristics[:product_line_shares].collect do |product_line_share|
                # go to the product_lines_sectors table
                # look up all the rows where ps_code = product_line_share.ps_code
                # take io_code and (ratio * product_line_share.share) for those rows
              end
            end
            
            quorum 'default' do
              raise "We need a merchant, merchant category, industry, or product_line"
            end
          end
          
          committee :product_line_shares do
            quorum 'from industry shares', :needs => [:industry_shares] do |characteristics|
              industry_shares = characteristics[:industry_shares]
              industries_product_lines = IndustriesProductLines.find :all,
                :conditions => { :naics_code => industry_shares.keys }
              industries_product_lines.inject({}) do |hash, industry_product_lines|
                ps_code = industry_product_lines.ps_code
                naics_code = industry_product_lines.naics_code
                industry_shares_ratio = industry_shares[naics_code]
                hash[ps_code] = 
                  industry_product_lines.ratio * industry_shares_ratio
                hash
              end
            end
          end
          
          committee :industry_shares do
            quorum 'from merchant category', :needs => [:merchant_category] do |characteristics|
              mc_industries = characteristics[:merchant_category].merchant_categories_industries
              mc_industries.inject({}) do |hash, mci|
                hash[mci.naics_code] = mci.ratio
                hash
              end
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
      end
    end
  end
end

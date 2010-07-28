require 'leap'
require 'timeframe'

module BrighterPlanet
  module Purchase
    module CarbonModel
      def self.included(base)
        base.extend ::Leap::Subject
        base.extend FastTimestamp
        base.decide :emission, :with => :characteristics do
          committee :emission do |provides|
            quorum 'from_emission_factor_and_adjusted_cost', :needs => [:emission_factor, :adjusted_cost] do |characteristics|
              #       lbs CO2e / 2002 US $              2002 US $
              characteristics[:emission_factor] * characteristic[:adjusted_cost]
            end
            
            quorum 'default' do
              raise "The purchase's default emission quorum should never be called"
            end
          end
          
          committee :emission_factor do |provides|
            quorum 'from_sector', :needs => [:sector] do |characteristics|
              characteristics[:sector]
            end
            
            quorum 'default' do
              # FIXME TODO figure out a real fallback emission factor
              100
            end
          end
          
          committee :sector do |provides|
            quorum 'from_industry', :needs => [:industry] do |characteristics|
              characteristics[:industry].sector
            end
            
            quorum 'from_product_line', :needs => [:product_line] do |characteristics|
              characteristics[:product_line].sector
            end
            
            quorum 'default' do
              raise "We need a merchant, merchant category, industry, or product_line"
            end
          end
          
          committee :industry do |provides|
            quorum 'from_merchant_category', :needs => [:merchant_category] do |characteristics|
              characteristics[:merchant_category].industry
            end
          end
          
          committee :merchant_category do |provides|
            quorum 'from_merchant', :needs => [:merchant] do |characteristics|
              characteristics[:merchant].merchant_category
            end
          end
          
          committee :adjusted_cost do |provides|
            quorum 'from_cost_and_date', :needs => [:cost, :date] do |characteristics|
              # FIXME TODO convert cost to 2002 dollars based on date
              characteristics[:cost]
            end
            
            quorum 'from_purchase_amount_and_date', :needs => [:purchase_amount, :date] do |characteristics|
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

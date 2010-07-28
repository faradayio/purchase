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
            quorum 'from emissions factor and adjusted cost', :needs => [:emission_factor, :adjusted_cost] do
              #       lbs CO2e / 2002 US $              2002 US $
              characteristics[:emission_factor] * characteristic[:adjusted_cost]
            end
            
            quorum 'default' do
              raise "The purchase's default emission quorum should never be called"
            end
          end
          
          committee :emission_factor do
            quorum 'from sectors', :needs => [:sector] do |characteristics|
              characteristics[:sector]
            end
            
            quorum 'default' do
              # FIXME TODO figure out a real fallback emission factor
              100
            end
          end
          
          committee :sector do
            quorum 'from industries', :needs => [:industries] do |characteristics|
              characteristics[:industries].sectors
            end
            
            quorum 'from product line', :needs => [:product_line] do |characteristics|
              characteristics[:product_line].sectors
            end
            
            quorum 'default' do
              raise "We need a merchant, merchant category, industries, or product_line"
            end
          end
          
          committee :industries do
            quorum 'from merchant category', :needs => [:merchant_category] do |characteristics|
              characteristics[:merchant_category].industries
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

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
            provides.quorum :from_emission_factor_and_adjusted_cost, :needs => [:emission_factor, :adjusted_cost] do |characteristics|
              #       lbs CO2e / 2002 US $              2002 US $
              characteristics[:emission_factor] * characteristic[:adjusted_cost]
            end
            
            provides.quorum :default do
              raise "The purchase's default emission quorum should never be called"
            end
          end
          
          committee :emission_factor do |provides|
            # FIXME TODO this actually has to access the io model and return a whole array of data
            provides.quorum :from_sector, :needs => [:sector] do |characteristics|
              characteristics[:sector]
            
              provides.quorum :default do
                # fallback emission_factor
              end
            end
          end
            
          committee :sector do |provides|
            provides.quorum :from_industry, :needs => [:industry] do |characteristics|
              if characteristics[:industry].sector != #FIXME TODO the io sectors for wholesale and retail trade
                characteristics[:industry].sector
              else
                characteristics[:industry].product_line.industry # FIXME TODO look up the industries that make the product lines that are made by the original industry
              end
            end
          end
            
          committee :industry do |provides|
            provides.quorum :from_merchant_category, :needs => [:merchant_category] do |characteristics|
              characteristics[:merchant_category].industry
            end
          end
            
          committee :merchant_category do |provides|
            provides.quorum :from_merchant, :needs => [:merchant] do |characteristics|
              characteristics[:merchant].merchant_category
            end
          end
            
          committee :adjusted_cost do |provides|
            # for now assuming is always US $ - later may need to figure out currency
            provides.quorum :from_cost_and_date, :needs => [:cost, :date] do |characteristics|
              # convert to 2002 US $ based on date and cost
            end
            
            provides.quorum :from_purchase_amount_and_date, :needs => [:purchase_amount, :date] do |characteristics|
              # adjust for tax and then convert to 2002 US $ based on date and cost
            end
          end
        end
        # FIXME TODO make other committees to report emissions by gas, by io sector, etc.
      end
    end
  end
end

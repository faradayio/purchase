require 'characterizable'

module BrighterPlanet
  module Purchase
    module Characterization
      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has :merchant do |merchant|
            merchant.reveals :merchant_category
          end
          has :industry
          has :product_line
          has :sector
          has :purchase_amount # full purchase amount
          has :tax             # tax portion of purchase
          has :cost            # cost before tax
          has :line_item
          has :customer_code
          has :zip_code
          has :date
        end
      end
    end
  end
end

require 'characterizable'

module BrighterPlanet
  module Purchase
    module Characterization
      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has :merchant
          has :merchant_category
          has :industries
          has :product_lines
          has :sectors
          has :purchase_amount # full purchase amount
          has :tax             # tax portion of purchase
          has :cost            # cost before tax
          has :line_item       # text describing what was purchased
          has :customer_code
          has :zip_code
          has :date
        end
      end
    end
  end
end

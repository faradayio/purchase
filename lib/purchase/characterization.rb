require 'characterizable'

module BrighterPlanet
  module Purchase
    module Characterization
      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has.characteristic :merchant
          has.characteristic :merchant_category
          has.characteristic :industry
          has.characteristic :product_line
          has.characteristic :io_sector
          has.characteristic :purchase_amount # full purchase amount
          has.characteristic :tax             # tax portion of purchase
          has.characteristic :cost            # cost before tax
          has.characteristic :line_item
          has.characteristic :customer_code
          has.characteristic :zip_code
          has.characteristic :date
        end
      end
    end
  end
end

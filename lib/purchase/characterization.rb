require 'characterizable'

module BrighterPlanet
  module Purchase
    module Characterization
      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has :cost            # cost before tax
          has :purchase_amount # full purchase amount, including tax
          has :tax             # tax portion of purchase
          has :date
          has :merchant
          has :merchant_category
          has :industry
        end
        base.add_implicit_characteristics
      end
    end
  end
end

require 'characterizable'

module BrighterPlanet
  module Purchase
    module Characterization
      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has :merchant
          has :merchant_category
          has :naics_code
          has :total           # full purchase amount
          has :tax             # tax portion of purchase
          has :cost            # cost before tax
          has :date
        end
      end
    end
  end
end

module BrighterPlanet
  module Purchase
    module Fallback
      def self.included(base)
        base.falls_back_on
      end
    end
  end
end

require 'emitter'

module BrighterPlanet
  module Purchase
    attr_accessor :merchant_category_code

    extend BrighterPlanet::Emitter

    class << self
      def sector_direct_requirements_adapter
        @sector_direct_requirements_adapter ||= TestSectorDirectRequirementsAdapter
      end
      def sector_direct_requirements_adapter=(val)
        @sector_direct_requirements_adapter = val
      end
    end
  end
end

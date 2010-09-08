require 'emitter'

module BrighterPlanet
  module Purchase
    attr_accessor :merchant_category_code

    extend BrighterPlanet::Emitter

    class << self
      def sector_direct_requirements_adapter
        return @sector_direct_requirements_adapter if @sector_direct_requirements_adapter

        require 'test_support/test_sector_direct_requirements_adapter'
        @sector_direct_requirements_adapter = TestSectorDirectRequirementsAdapter
      end
      def sector_direct_requirements_adapter=(val)
        @sector_direct_requirements_adapter = val
      end

      def impact_vectors_adapter
        return @impact_vectors_adapter if @impact_vectors_adapter

        require 'test_support/test_impact_vectors_adapter'
        @impact_vectors_adapter = TestImpactVectorsAdapter
      end
      def impact_vectors_adapter=(val)
        @impact_vectors_adapter = val
      end

      def key_map
        impact_vectors_adapter.key_map
      end
    end
  end
end

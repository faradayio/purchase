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
        @key_map ||= (1..26).to_a.map(&:to_s) + %w{44100 44101 44102 44103 44104 44105}
      end
      def key_map=(val)
        @key_map = val
      end
    end
  end
end

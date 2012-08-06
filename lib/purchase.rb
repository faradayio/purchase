require 'emitter'

require 'purchase/impact_model'
require 'purchase/characterization'
require 'purchase/data'
require 'purchase/relationships'
require 'purchase/summarization'

module BrighterPlanet
  module Purchase
    extend BrighterPlanet::Emitter

    class << self
      def sector_direct_requirements_adapter
        @sector_direct_requirements_adapter
      end
      def sector_direct_requirements_adapter=(val)
        @sector_direct_requirements_adapter = val
      end

      def impact_vectors_adapter
        @impact_vectors_adapter
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

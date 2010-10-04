module BrighterPlanet
  module Purchase
    module Relationships
      def self.included(target)
        target.belongs_to :merchant,          :foreign_key => 'merchant_id'
        target.belongs_to :merchant_category, :foreign_key => 'mcc'
        target.belongs_to :industry,          :foreign_key => 'naics_code'
      end
    end
  end
end

require 'data_miner'

module BrighterPlanet
  module Purchase
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            float   'cost'
            string  'cost_units'
            float   'purchase_amount'
            string  'purchase_amount_units'
            float   'tax'
            string  'tax_units'
            date    'date'
            string  'merchant_id'
            string  'mcc'
            string  'naics_code'
          end
          
          process :run_data_miner_on_belongs_to_associations
        end
      end
    end
  end
end

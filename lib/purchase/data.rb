require 'data_miner'

module BrighterPlanet
  module Purchase
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            string  'merchant_id'
            string  'mcc'
            string  'naics_code'
            string  'pscode'
            string  'io_code'
            float   'purchase_amount'
            string  'purchase_amount_units'
            float   'tax'
            string  'tax_units'
            float   'cost'
            string  'cost_units'
            string  'line_item'
            string  'customer_code'
            string  'zip_code_name'
            date    'date'
            float   'adjusted_cost'
            string  'adjusted_cost_units'
            float   'emission_factor'
            string  'emission_factor_units'
          end
          
          process "Pull dependencies" do
            run_data_miner_on_belongs_to_associations
          end
        end
      end
    end
  end
end

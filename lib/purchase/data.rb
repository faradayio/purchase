require 'data_miner'

module BrighterPlanet
  module Purchase
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            integer 'merchant_id'
            string  'mcc'
            string  'naics_code' # FIXME TODO not sure how to deal with the fact that a single purchase may have multiple industries, product lines, and io sectors
            string  'pscode' # FIXME TODO not sure how to deal with the fact that a single purchase may have multiple industries, product lines, and io sectors
            string  'io_code' # FIXME TODO not sure how to deal with the fact that a single purchase may have multiple industries, product lines, and io sectors
            float   'purchase_amount'
            float   'tax'
            float   'cost'
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

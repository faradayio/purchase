module BrighterPlanet
  module Purchase
    module Data
      def self.included(base)
        base.create_table do
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
      end
    end
  end
end

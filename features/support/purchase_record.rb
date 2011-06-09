require 'active_record'
require 'falls_back_on'
require 'purchase'
require 'sniff'

class PurchaseRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::Purchase
  
  create_table do
    integer 'merchant_id'
    string  'mcc'
    string  'ps_code'
    string  'io_code'
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

end

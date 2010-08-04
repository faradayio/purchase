require 'sniff/database'

Sniff::Database.define_schema do
  create_table "purchase_records", :force => true do |t|
    t.integer 'merchant_id'
    t.string  'mcc'
    t.string  'ps_code'
    t.string  'io_code'
    t.float   'purchase_amount'
    t.float   'tax'
    t.float   'cost'
    t.string  'line_item'
    t.string  'customer_code'
    t.string  'zip_code_name'
    t.date    'date'
    t.float   'adjusted_cost'
    t.string  'adjusted_cost_units'
    t.float   'emission_factor'
    t.string  'emission_factor_units'
  end
end

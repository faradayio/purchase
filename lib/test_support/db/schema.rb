require 'sniff/database'

Sniff::Database.define_schema do
  create_table "purchase_records", :force => true do |t|
    t.integer 'merchant_id'
    t.string  'mcc'
    t.string  'naics_code' # FIXME TODO not sure how to deal with the fact that a single purchase may have multiple industries, product lines, and io sectors
    t.string  'pscode' # FIXME TODO not sure how to deal with the fact that a single purchase may have multiple industries, product lines, and io sectors
    t.string  'io_code' # FIXME TODO not sure how to deal with the fact that a single purchase may have multiple industries, product lines, and io sectors
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

require 'active_record'
require 'falls_back_on'
require 'purchase'
require 'sniff'

class PurchaseRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::Purchase
  
  belongs_to :merchant,          :foreign_key => 'merchant_id'
  belongs_to :merchant_category, :foreign_key => 'mcc'

  attr_accessor :naics_code
end

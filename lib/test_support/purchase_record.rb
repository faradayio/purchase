require 'active_record'
require 'falls_back_on'
require 'purchase'
require 'sniff'

class PurchaseRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::Purchase
  
  belongs_to :merchant,          :foreign_key => 'merchant_id'
  belongs_to :merchant_category, :foreign_key => 'mcc'
  # belongs_to :product_line,      :foreign_key => 'ps_code'
  # belongs_to :sector,            :foreign_key => 'io_code'

  attr_accessor :naics_codes, :ps_codes
  def naics_codes
    @naics_codes ||= []
  end
  def ps_codes
    @ps_codes ||= []
  end
end

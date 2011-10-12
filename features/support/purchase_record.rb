require 'active_record'
require 'falls_back_on'
require 'purchase'
require 'sniff'

class PurchaseRecord < ActiveRecord::Base
  include BrighterPlanet::Emitter
  include BrighterPlanet::Purchase
end

require 'emitter'

module BrighterPlanet
  module Purchase
    attr_accessor :merchant_category_code

    extend BrighterPlanet::Emitter
  end
end

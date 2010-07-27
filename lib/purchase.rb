module BrighterPlanet
  module Purchase
    attr_accessor :merchant_category_code

    module ClassMethods
      def included(base)
        require 'cohort_scope'
        require 'falls_back_on'
        require 'falls_back_on/active_record_ext'

        require 'purchase/carbon_model'
        require 'purchase/characterization'
        require 'purchase/data'
        require 'purchase/summarization'

        base.send :include, BrighterPlanet::Purchase::CarbonModel
        base.send :include, BrighterPlanet::Purchase::Characterization
        base.send :include, BrighterPlanet::Purchase::Data
        base.send :include, BrighterPlanet::Purchase::Summarization
      end
      def flight_model
        if Object.const_defined? 'Purchase'
          ::Purchase
        elsif Object.const_defined? 'PurchaseRecord'
          PurchaseRecord
        else
          raise 'There is no purchase model'
        end
      end
    end
    extend ClassMethods
  end
end

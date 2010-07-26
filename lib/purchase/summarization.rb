require 'summary_judgement'

module BrighterPlanet
  module Flight
    module Summarization
      def self.included(base)
        base.extend SummaryJudgement
        base.summarize do |has|
          has.identity 'purchase'

          has.verb :take
          has.aspect :perfect

          has.modifier lambda { |purchase| "from #{flight.merchant}" }, :if => :merchant
          has.modifier lambda { |purchase| "(#{purchase.inudstry} industry)" }, :if => :industry
          has.modifier lambda { |purchase| "for $#{purchase.purchase_amount}" }, :if => :purchase_amount
          has.modifier lambda { |purchase| "on #{date.to_formatted_s(:archive)}" } :if => :date
        end
      end
    end
  end
end

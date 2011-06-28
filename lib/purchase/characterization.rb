require 'action_view'

module BrighterPlanet
  module Purchase
    module Characterization
      extend ::ActionView::Helpers::TextHelper

      def self.included(base)
        base.characterize do
          has :cost            # cost before tax
          has :purchase_amount # full purchase amount, including tax
          has :tax             # tax portion of purchase
          has :date
          has :merchant do |m|
             m.name
          end
          has :merchant_category do |mc|
             mc.description
          end
          has :merchant_category_industries do |mci|
             pluralize(mci.count, 'merchant category')
          end
          has :industry do |ind|
             ind.description
          end
          has :trade_industry_ratios do |tir|
             pluralize(tir.count, 'trade industry ratio')
          end
          has :non_trade_industry_ratios do |ntir|
             pluralize(ntir.count, 'non-trade industry ratio')
          end
          has :product_line_ratios do |plr|
             pluralize(plr.count, 'product line ratio')
          end
          has :product_line_industry_product_ratios do |plipr|
             pluralize(plipr.count, 'product line industry product ratio')
          end
          has :industry_product_ratios do |ipr|
             pluralize(ipr.count, 'industry product ratio')
          end
          has :industry_ratios do |ir|
             pluralize(ir.count, 'industry ratio')
          end
          has :industry_sector_ratios do |isr|
             pluralize(isr.count, 'industry sector ratio')
          end
          has :industry_sector_shares do |isr|
             pluralize(isr.count, 'industry sector share')
          end
          has :sector_shares do |isr|
            "#{isr.size}-element sector shares vector"
          end
          has :sector_direct_requirements do |sdr|
            "#{sdr.row_size}x#{sdr.column_size} sector direct requirements matrix"
          end
          has :economic_flows do |ef|
            "#{ef.size}-element economic flows vector"
          end
          has :impact_vectors do |iv|
            "#{iv.row_size}x#{iv.column_size} impact vector"
          end
          has :impacts do |i|
            "#{i.size}-element impacts vector"
          end
        end
      end
    end
  end
end

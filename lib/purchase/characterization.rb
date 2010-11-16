require 'characterizable'
require 'action_view'

module BrighterPlanet
  module Purchase
    module Characterization
      extend ActionView::Helpers::TextHelper

      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has :cost            # cost before tax
          has :purchase_amount # full purchase amount, including tax
          has :tax             # tax portion of purchase
          has :date
          has :merchant do
            displays { |m| m.name }
          end
          has :merchant_category do
            displays { |mc| mc.description }
          end
          has :merchant_category_industries do
            displays { |mci| pluralize(mci.count, 'merchant category') }
          end
          has :industry do
            displays { |ind| ind.description }
          end
          has :trade_industry_ratios do
            displays { |tir| pluralize(tir.count, 'trade industry ratio') }
          end
          has :non_trade_industry_ratios do
            displays { |ntir| pluralize(ntir.count, 'non-trade industry ratio') }
          end
          has :product_line_ratios do
            displays { |plr| pluralize(plr.count, 'product line ratio') }
          end
          has :product_line_industry_product_ratios do
            displays { |plipr| pluralize(plipr.count, 'product line industry product ratio') }
          end
          has :industry_product_ratios do
            displays { |ipr| pluralize(ipr.count, 'industry product ratio') }
          end
          has :industry_ratios do
            displays { |ir| pluralize(ir.count, 'industry ratio') }
          end
          has :industry_sector_ratios do
            displays { |isr| pluralize(isr.count, 'industry sector ratio') }
          end
          has :industry_sector_shares do
            displays { |isr| pluralize(isr.count, 'industry sector share') }
          end
          has :sector_shares do
            displays { |isr| "#{isr.size}-element sector shares vector" }
          end
          has :sector_direct_requirements do
            displays { |sdr| "#{sdr.row_size}x#{sdr.column_size} sector direct requirements matrix" }
          end
          has :economic_flows do
            displays { |ef| "#{ef.size}-element economic flows vector" }
          end
          has :impact_vectors do
            displays { |iv| "#{iv.row_size}x#{iv.column_size} impact vector" }
          end
          has :impacts do
            displays { |i| "#{i.size}-element impacts vector" }
          end
        end
        base.add_implicit_characteristics
      end
    end
  end
end

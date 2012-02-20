module BrighterPlanet
  module Purchase
    module Characterization
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
          has :merchant_category_industries do |mci| # for display; not expected to be input
             "#{mci.count} merchant category(s)"
          end
          has :sic_industry do |ind|
            ind.description
          end
          has :industry do |ind|
             ind.description
          end
          has :trade_industry_ratios do |tir| # for display; not expected to be input
             "#{tir.count} trade industry ratio(s)"
          end
          has :non_trade_industry_ratios do |ntir| # for display; not expected to be input
             "#{ntir.count} non-trade industry ratio(s)"
          end
          has :product_line_ratios do |plr| # for display; not expected to be input
             "#{plr.count} product line ratio(s)"
          end
          has :product_line_industry_product_ratios do |plipr| # for display; not expected to be input
             "#{plipr.count} product line industry product ratio(s)"
          end
          has :industry_product_ratios do |ipr| # for display; not expected to be input
             "#{ipr.count} industry product ratio(s)"
          end
          has :industry_ratios do |ir| # for display; not expected to be input
             "#{ir.count} industry ratio(s)"
          end
          has :industry_sector_ratios do |isr| # for display; not expected to be input
             "#{isr.count} industry sector ratio(s)"
          end
          has :industry_sector_shares do |isr| # for display; not expected to be input
             "#{isr.count} industry sector share(s)"
          end
          has :sector_shares do |isr| # for display; not expected to be input
            "#{isr.size}-element sector shares vector"
          end
          has :sector_direct_requirements do |sdr| # for display; not expected to be input
            "#{sdr.row_size}x#{sdr.column_size} sector direct requirements matrix"
          end
          has :economic_flows do |ef| # for display; not expected to be input
            "#{ef.size}-element economic flows vector"
          end
          has :impact_vectors do |iv| # for display; not expected to be input
            "#{iv.row_size}x#{iv.column_size} impact vector"
          end
          has :impacts do |i| # for display; not expected to be input
            "#{i.size}-element impacts vector"
          end
        end
      end
    end
  end
end

class Merchant < ActiveRecord::Base
  col :id, :type => :integer
  col :name
  col :mcc

  belongs_to :merchant_category, :foreign_key => :mcc

  data_miner do
    process :auto_upgrade!
  end
end

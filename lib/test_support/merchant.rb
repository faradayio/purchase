# Merchant is defined in CM1 rather than Earth, so we need to define it here for testing
require 'earth/model'

class Merchant < ActiveRecord::Base
    extend Earth::Model

    TABLE_STRUCTURE = <<-EOS

CREATE TABLE merchants
  (
     id                                 INTEGER NOT NULL PRIMARY KEY,
     name                               CHARACTER VARYING(255),
     mcc                                CHARACTER VARYING(255)
  );

EOS

  belongs_to :merchant_category, :foreign_key => :mcc
end

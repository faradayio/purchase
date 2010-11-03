Feature: Purchase Characterizations
  The purchase model should be characterized

  Scenario: Merchant category characteristic
    Given a purchase has "merchant_category.mcc" of "2222"
    And it has "cost" of "100"
    When emissions are calculated
    Then the "merchant_category" characteristic should be displayed as "Fantasy creature product shops"

  Scenario: Merchant category industries characteristic
    Given a purchase has "merchant_category.mcc" of "2222"
    And it has "cost" of "100"
    When emissions are calculated
    Then the "merchant_category_industries" characteristic should be displayed as "2 merchant categories"

  Scenario: Trade industry ratios characteristic
    Given a purchase has "merchant_category.mcc" of "2222"
    And it has "cost" of "100"
    When emissions are calculated
    Then the "trade_industry_ratios" characteristic should be displayed as "1 trade industry ratio"

  Scenario: Non-trade industry ratios characteristic
    Given a purchase has "merchant_category.mcc" of "2222"
    And it has "cost" of "100"
    When emissions are calculated
    Then the "non_trade_industry_ratios" characteristic should be displayed as "1 non-trade industry ratio"

  Scenario: Sector direct requirements characteristic
    Given a purchase has "merchant_category.mcc" of "2222"
    And it has "cost" of "100"
    When emissions are calculated
    Then the "sector_direct_requirements" characteristic should be displayed as "6x6 sector direct requirements matrix"


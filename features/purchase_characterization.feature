Feature: Purchase Characterizations
  The purchase model should be characterized

  Background:
    Given a Purchase

  Scenario: Merchant characteristic
    Given it has "merchant.id" of "2"
    When impacts are calculated
    Then the "merchant" characteristic should be displayed as "Derek's Fantasy-Mart"

  Scenario: Merchant category characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "merchant_category" characteristic should be displayed as "Fantasy creature product shops"

  Scenario: Merchant category industries characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "merchant_category_industries" characteristic should be displayed as "2 merchant category(s)"

  Scenario: Sic industry characteristic
    Given it has "sic_industry.code" of "1111"
    When impacts are calculated
    Then the "sic_industry" characteristic should be displayed as "A simple industry"

  Scenario: Industry characteristic
    Given it has "industry.naics_code" of "111111"
    When impacts are calculated
    Then the "industry" characteristic should be displayed as "A simple industry"

  Scenario: Trade industry ratios characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "trade_industry_ratios" characteristic should be displayed as "1 trade industry ratio(s)"

  Scenario: Non-trade industry ratios characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "non_trade_industry_ratios" characteristic should be displayed as "1 non-trade industry ratio(s)"

  Scenario: Product line ratios characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "product_line_ratios" characteristic should be displayed as "2 product line ratio(s)"

  Scenario: Product line industry product ratios characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "product_line_industry_product_ratios" characteristic should be displayed as "4 product line industry product ratio(s)"

  Scenario: Industry product ratios characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "industry_product_ratios" characteristic should be displayed as "2 industry product ratio(s)"

  Scenario: Industry ratios characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "industry_ratios" characteristic should be displayed as "3 industry ratio(s)"

  Scenario: Industry sector ratios characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "industry_sector_ratios" characteristic should be displayed as "4 industry sector ratio(s)"

  Scenario: Industry sector shares characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "industry_sector_shares" characteristic should be displayed as "4 industry sector share(s)"

  Scenario: Sector shares characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "sector_shares" characteristic should be displayed as "6-element sector shares vector"

  Scenario: Sector direct requirements characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "sector_direct_requirements" characteristic should be displayed as "6x6 sector direct requirements matrix"

  Scenario: Economic flows characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "economic_flows" characteristic should be displayed as "6-element economic flows vector"

  Scenario: Impact vector characteristic
    Pending a proper test for impact vector

  Scenario: Impacts characteristic
    Given it has "merchant_category.mcc" of "2222"
    When impacts are calculated
    Then the "impacts" characteristic should be displayed as "6-element impacts vector"

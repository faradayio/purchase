Feature: Purchase Characterizations
  The purchase model should be characterized

  Scenario: Merchant category industries characteristic
    Given a purchase has "merchant_category.mcc" of "2222"
    And it has "cost" of "100"
    When emissions are calculated
    Then the "merchant_category_industries" characteristic should be displayed as "2 merchant categories"

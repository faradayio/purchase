Feature: Purchase Emissions Calculations
  The purchase model should generate correct emission calculations
  
  Scenario Outline: Calculations starting from a merchant
    Given a purchase has "merchant.id" of "<id>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 0.001 kgs of <emission>
    Examples:
      | id  | cost   | date       | emission |
      | 1   | 100.00 | 2010-07-28 |120694.715|
      | 2   | 100.00 | 2010-07-28 |110152.836|
      | 3   | 100.00 | 2010-07-28 |118426.103|
      | 4   | 100.00 | 2010-07-28 |115090.859|
      | 5   | 100.00 | 2010-07-28 |110346.441|

  Scenario Outline: Calculations starting from a merchant with purchase amount
    Given a purchase has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | id  | amount | date       | emission |
      | 1   | 100.00 | 2010-07-28 |108625.243|
      | 2   | 100.00 | 2010-07-28 | 99137.552|
      | 3   | 100.00 | 2010-07-28 |106583.492|
      | 4   | 100.00 | 2010-07-28 |103581.773|
      | 5   | 100.00 | 2010-07-28 | 99311.797|
  
  Scenario Outline: Calculations starting from a merchant with purchase amount and tax
    Given a purchase has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    And it has "tax" of "<tax>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | id  | amount | tax  | date       | emission |
      | 1   | 100.00 | 8.00 | 2010-07-28 |111039.138|
      | 2   | 100.00 | 8.00 | 2010-07-28 |101340.609|
      | 3   | 100.00 | 8.00 | 2010-07-28 |108952.014|
      | 4   | 100.00 | 8.00 | 2010-07-28 |105883.590|
      | 5   | 100.00 | 8.00 | 2010-07-28 |101518.726|
  
  Scenario Outline: Calculations starting from a merchant category
    Given a purchase has "merchant_category.mcc" of "<mcc>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 0.001 kgs of <emission>
    Examples:
      | mcc  | cost   | date       | emission |
      | 5111 | 100.00 | 2010-07-28 |120694.715|
      | 5111 | 12.00  | 2010-07-28 | 14483.365|
      | 5732 | 100.00 | 2010-07-28 |110152.836|
      | 5812 | 100.00 | 2010-07-28 |118426.103|
      | 3504 | 100.00 | 2010-07-28 |115090.859|
      | 5172 | 100.00 | 2010-07-28 |110346.441|

  Scenario Outline: Calculations starting from industry
    Given a purchase has "naics_code" of "<naics>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 0.001 kgs of <emission>
    Examples:
      | naics  | cost   | date       | emission |
      | 45321  | 100.00 | 2010-07-28 |120694.715|
      | 443112 | 100.00 | 2010-07-28 |110152.836|
      | 72211  | 100.00 | 2010-07-28 |118426.103|
      | 72111  | 100.00 | 2010-07-28 |115090.859|
      | 32411  | 100.00 | 2010-07-28 |112285.552|
      | 324121 | 100.00 | 2010-07-28 | 94684.359|
      | 324122 | 100.00 | 2010-07-28 |106509.038|
      | 324191 | 100.00 | 2010-07-28 |104811.125|
      | 324199 | 100.00 | 2010-07-28 |104355.468|

  Scenario Outline: Calculations without merchant, merchant category, or industry
    Given pending
    Given a purchase has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 0.1 kgs of <emission>
    Examples:
      | cost   | date       | emission |
      | 100.00 | 2010-07-28 |  82.85   |
      | 100.00 | 2010-08-28 |  82.85   |
      | 120.00 | 2010-08-28 |  99.42   |

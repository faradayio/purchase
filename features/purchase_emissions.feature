Feature: Purchase Emissions Calculations
  The purchase model should generate correct emission calculations

  Scenario: Calculations starting from nothing
    Given a purchase has nothing
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "120694.715"

  Scenario: Calculations starting from purchase amount
    Given a purchase has "purchase_amount" of "107.11"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "120694.715"

  Scenario: Calculations starting from date
    Given a purchase has "date" of "2010-07-28"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "120694.715"

  Scenario Outline: Calculations starting from a merchant
    Given a purchase has "merchant.id" of "<id>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | emission  |
      | 1   | 120694.715|
      | 2   | 110152.836|
      | 3   | 118426.103|
      | 4   | 115090.859|
      | 5   | 110346.441|

  Scenario Outline: Calculations starting from a merchant with purchase amount
    Given a purchase has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | amount | emission  |
      | 1   | 107.11 | 120694.715|
      | 2   | 107.11 | 110152.836|
      | 3   | 107.11 | 118426.103|
      | 4   | 107.11 | 115090.859|
      | 5   | 107.11 | 110346.441|
  
  Scenario Outline: Calculations starting from a merchant with purchase amount and date
    Given a purchase has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | amount | date       | emission  |
      | 1   | 107.11 | 2010-07-28 | 120694.715|
      | 2   | 107.11 | 2010-07-28 | 110152.836|
      | 3   | 107.11 | 2010-07-28 | 118426.103|
      | 4   | 107.11 | 2010-07-28 | 115090.859|
      | 5   | 107.11 | 2010-07-28 | 110346.441|

  Scenario Outline: Calculations starting from a merchant with purchase amount, date, and tax
    Given a purchase has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    And it has "tax" of "<tax>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | amount | tax  | date       | emission  |
      | 1   | 108.00 | 8.00 | 2010-07-28 | 120694.715|
      | 2   | 108.00 | 8.00 | 2010-07-28 | 110152.836|
      | 3   | 108.00 | 8.00 | 2010-07-28 | 118426.103|
      | 4   | 108.00 | 8.00 | 2010-07-28 | 115090.859|
      | 5   | 108.00 | 8.00 | 2010-07-28 | 110346.441|
  
  Scenario Outline: Calculations starting from a merchant category
    Given a purchase has "merchant_category.mcc" of "<mcc>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | mcc  | cost   | date       | emission  |
      | 5111 | 100.00 | 2010-07-28 | 120694.715|
      | 5732 | 100.00 | 2010-07-28 | 110152.836|
      | 5812 | 100.00 | 2010-07-28 | 118426.103|
      | 3504 | 100.00 | 2010-07-28 | 115090.859|
      | 5172 | 100.00 | 2010-07-28 | 110346.441|

  Scenario Outline: Calculations starting from industry
    Given a purchase has "naics_code" of "<naics>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
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

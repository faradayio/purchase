Feature: Purchase Emissions Calculations
  The purchase model should generate correct emission calculations

  Scenario: Calculations starting from nothing
    Given a purchase has nothing
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "756.667"

  Scenario: Calculations starting from purchase amount
    Given a purchase has "purchase_amount" of "107.11"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "756.667"

  Scenario: Calculations starting from date
    Given a purchase has "date" of "2010-07-28"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "756.667"

  Scenario Outline: Calculations starting from a merchant
    Given a purchase has "merchant.id" of "<id>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | emission |
      | 1   |  756.667 |
      | 2   |  828.562 |
      | 3   | 1158.876 |
      | 4   | 1007.731 |
      | 5   | 1034.378 |

  Scenario Outline: Calculations starting from a merchant with purchase amount
    Given a purchase has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | amount | emission |
      | 1   | 107.11 |  756.667 |
      | 2   | 107.11 |  828.562 |
      | 3   | 107.11 | 1158.876 |
      | 4   | 107.11 | 1007.731 |
      | 5   | 107.11 | 1034.378 |
  
  Scenario Outline: Calculations starting from a merchant with purchase amount and date
    Given a purchase has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | amount | date       | emission |
      | 1   | 107.11 | 2010-07-28 |  756.667 |
      | 2   | 107.11 | 2010-07-28 |  828.562 |
      | 3   | 107.11 | 2010-07-28 | 1158.876 |
      | 4   | 107.11 | 2010-07-28 | 1007.731 |
      | 5   | 107.11 | 2010-07-28 | 1034.378 |

  Scenario Outline: Calculations starting from a merchant with purchase amount, date, and tax
    Given a purchase has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    And it has "tax" of "<tax>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | amount | tax  | date       | emission |
      | 1   | 108.00 | 8.00 | 2010-07-28 |  756.667 |
      | 2   | 108.00 | 8.00 | 2010-07-28 |  828.562 |
      | 3   | 108.00 | 8.00 | 2010-07-28 | 1158.876 |
      | 4   | 108.00 | 8.00 | 2010-07-28 | 1007.731 |
      | 5   | 108.00 | 8.00 | 2010-07-28 | 1034.378 |
  
  Scenario Outline: Calculations starting from a merchant category
    Given a purchase has "merchant_category.mcc" of "<mcc>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | mcc  | cost   | date       | emission |
      | 5111 | 100.00 | 2010-07-28 |  756.667 |
      | 5732 | 100.00 | 2010-07-28 |  828.562 |
      | 5812 | 100.00 | 2010-07-28 | 1158.876 |
      | 3504 | 100.00 | 2010-07-28 | 1007.731 |
      | 5172 | 100.00 | 2010-07-28 | 1034.378 |

  Scenario Outline: Calculations starting from industry
    Given a purchase has "naics_code" of "<naics>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within "0.001" kgs of "<emission>"
    Examples:
      | naics  | cost   | date       | emission |
      | 45321  | 100.00 | 2010-07-28 |  756.667 |
      | 443112 | 100.00 | 2010-07-28 |  828.562 |
      | 72211  | 100.00 | 2010-07-28 | 1158.876 |
      | 72111  | 100.00 | 2010-07-28 | 1007.731 |
      | 32411  | 100.00 | 2010-07-28 | 1029.897 |
      | 324121 | 100.00 | 2010-07-28 | 1032.748 |
      | 324122 | 100.00 | 2010-07-28 | 1029.932 |
      | 324191 | 100.00 | 2010-07-28 | 1059.298 |
      | 324199 | 100.00 | 2010-07-28 | 1087.243 |

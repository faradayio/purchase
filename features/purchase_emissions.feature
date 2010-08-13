Feature: Purchase Emissions Calculations
  The purchase model should generate correct emission calculations
  
  Scenario Outline: Calculations starting from a merchant
    Given a purchase has "merchant.id" of "<id>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | id  | cost   | date       | emission |
      | 1   | 100.00 | 2010-07-28 |  48.29   |
      | 2   | 100.00 | 2010-07-28 |  52.88   |
      | 3   | 100.00 | 2010-07-28 |  66.28   |
      | 4   | 100.00 | 2010-07-28 |  46.31   |
      | 5   | 100.00 | 2010-07-28 | 147.47   |
  
  Scenario Outline: Calculations starting from a merchant category
    Given a purchase has "merchant_category.mcc" of "<mcc>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 0.1 kgs of <emission>
    Examples:
      | mcc  | cost   | date       | emission |
      | 5111 | 100.00 | 2010-07-28 |  48.29   |
      | 5732 | 100.00 | 2010-07-28 |  52.88   |
      | 5812 | 100.00 | 2010-07-28 |  66.28   |
      | 3504 | 100.00 | 2010-07-28 |  46.31   |
      | 5172 | 100.00 | 2010-07-28 | 147.47   |

  Scenario Outline: Calculations starting from industry
    Given a purchase has "naics_code" of "<naics>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 0.1 kgs of <emission>
    Examples:
      | naics  | cost   | date       | emission |
      | 45321  | 100.00 | 2010-07-28 |  48.29   |
      | 443112 | 100.00 | 2010-07-28 |  52.88   |
      | 72211  | 100.00 | 2010-07-28 |  66.28   |
      | 72111  | 100.00 | 2010-07-28 |  46.31   |
      | 32411  | 100.00 | 2010-07-28 | 132.56   |
      | 324121 | 100.00 | 2010-07-28 |   5.39   |
      | 324122 | 100.00 | 2010-07-28 |   3.73   |
      | 324191 | 100.00 | 2010-07-28 |   0.83   |
      | 324199 | 100.00 | 2010-07-28 |   4.97   |

  Scenario Outline: Calculations without merchant, merchant category, or industry
    Given a purchase has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 0.1 kgs of <emission>
    Examples:
      | cost   | date       | emission |
      | 100.00 | 2010-07-28 |  82.85   |
      | 100.00 | 2010-08-28 |  82.85   |
      | 120.00 | 2010-08-28 |  99.42   |

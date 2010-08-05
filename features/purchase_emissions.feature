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
      | 1   | 100.00 | 2010-07-28 | 108.2    |
      | 2   | 100.00 | 2010-07-28 |  87.0    |
      | 3   | 100.00 | 2010-07-28 |  80.0    |
      | 4   | 100.00 | 2010-07-28 | 100.0    |
      | 5   | 100.00 | 2010-07-28 | 178.0    |
  
  Scenario Outline: Calculations starting from a merchant category
    Given a purchase has "merchant_category.mcc" of "<mcc>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | mcc  | cost   | date       | emission |
      | 5111 | 100.00 | 2010-07-28 | 108.2    |
      | 5732 | 100.00 | 2010-07-28 |  87.0    |
      | 5812 | 100.00 | 2010-07-28 |  80.0    |
      | 3504 | 100.00 | 2010-07-28 | 100.0    |
      | 5172 | 100.00 | 2010-07-28 | 178.0    |

  Scenario Outline: Calculations starting from industry NAICS codes
    Given pending - do we really need this?
    Given a purchase has "naics_codes" including "<naics>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | naics   | cost   | date       | emission |
      | 45321   | 100.00 | 2010-07-28 | 108.2    |
      | 443112  | 100.00 | 2010-07-28 |  87      |
      | 72211   | 100.00 | 2010-07-28 |  80      |
      | 7221111 | 100.00 | 2010-07-28 | 100      |
      | 32411   | 100.00 | 2010-07-28 | 160      |
      | 324121  | 100.00 | 2010-07-28 |   6.5    |
      | 324122  | 100.00 | 2010-07-28 |   4.5    |
      | 324191  | 100.00 | 2010-07-28 |   1      |
      | 324199  | 100.00 | 2010-07-28 |   6      |


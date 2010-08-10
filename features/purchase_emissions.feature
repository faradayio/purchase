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
      | 1   | 100.00 | 2010-07-28 |  89.6    |
      | 2   | 100.00 | 2010-07-28 |  72.1    |
      | 3   | 100.00 | 2010-07-28 |  66.3    |
      | 4   | 100.00 | 2010-07-28 |  82.9    |
      | 5   | 100.00 | 2010-07-28 | 147.5    |
  
  Scenario Outline: Calculations starting from a merchant category
    Given a purchase has "merchant_category.mcc" of "<mcc>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | mcc  | cost   | date       | emission |
      | 5111 | 100.00 | 2010-07-28 |  89.6    |
      | 5732 | 100.00 | 2010-07-28 |  72.8    |
      | 5812 | 100.00 | 2010-07-28 |  66.3    |
      | 3504 | 100.00 | 2010-07-28 |  82.9    |
      | 5172 | 100.00 | 2010-07-28 | 147.5    |

  Scenario Outline: Calculations starting from industry NAICS codes
    Given a purchase has "naics_codes" including "<naics>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | naics        | cost   | date       | emission |
      | 45321        | 100.00 | 2010-07-28 |  89.6    |
      | 72211        | 100.00 | 2010-07-28 |  82.9    |
      | 32411,324121 | 100.00 | 2010-07-28 | 136.7    |
      

  Scenario Outline: Calculations starting from product line ps codes
    Given a purchase has "ps_codes" including "<ps_code>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | ps_code     | cost   | date       | emission |
      | 20370       | 100.00 | 2010-07-28 |  80.4    |
      | 20852       | 100.00 | 2010-07-28 | 116.0    |
      | 20375,20865 | 100.00 | 2010-07-28 |  87.0    |
      

  Scenario Outline: Calculations starting from sector io codes
    Given a purchase has "io_codes" including "<io_code>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | io_code       | cost   | date       | emission |
      | 334111        | 100.00 | 2010-07-28 | 107.7    |
      | 324191,324199 | 100.00 | 2010-07-28 | 58       |


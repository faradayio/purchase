Feature: Purchase Emissions Calculations
  The purchase model should generate correct emission calculations

  Scenario Outline: Standard Calculations for a MCC
    Given a purchase has "merchant_category_code" of "<mcc>"
    And it has "purchase_amount" of "<amount>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | mcc  | amount   | date       | emission |
      | 3504 | 100.00   | 2010-08-01 | 1000     |
      # | 5111 | 100.00   | 2010-08-01 | 1000     |
      # | 5172 | 100.00   | 2010-08-01 | 1000     |
      # | 5732 | 100.00   | 2010-08-01 | 1000     |
      # | 5812 | 100.00   | 2010-08-01 | 1000     |
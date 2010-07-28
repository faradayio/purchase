Feature: Purchase Emissions Calculations
  The purchase model should generate correct emission calculations

  Scenario Outline: Standard Calculations for a MCC
    Given a purchase has "merchant_category_code" of "<mcc>"
    And it has "purchase_amount" of "<amount>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | mcc  | amount | date       | emission |
      | 1771 | 831.23 | 2010-08-01 | 1153     |
      | 3007 |  11.00 | 2005-07-14 | 2070     |

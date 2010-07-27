Feature: Purchase Emissions Calculations
  The purchase model should generate correct emission calculations

  Scenario Outline: Standard Calculations for a MCC
    Given a purchase has "merchant_category_code" of "<mcc>"
    When emissions are calculated
    Then the emission value should be within 1 kgs of <emission>
    Examples:
      | mcc  | emission |
      | 1771 | 1153     |
      | 3007 | 2070     |

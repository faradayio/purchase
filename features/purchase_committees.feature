Feature: Purchase Committee Calculations
  The purchase model should generate correct committee calculations

  Scenario Outline: From purchase amount and date committee
    Given a purchase has "merchant_category_code" of "<mcc>"
    And it has "purchase_amount" of "<amount>"
    And it has "date" of "<date>"
    When emissions are calculated
    Then the from_purchase_amount_and_date committee should be exactly <adjusted_cost>
    Examples:
      | mcc  | amount | date       | adjusted_cost |
      | 1771 | 831.23 | 2010-08-01 |         700   |
      | 3007 |  11.00 | 2005-07-14 |          10   |

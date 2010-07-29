Feature: Purchase Committee Calculations
  The purchase model should generate correct committee calculations

  Scenario Outline: Adjusted cost committee from cost and date
    Given a purchase emitter
    And a characteristic "cost" of "<cost>"
    And characteristic "date" of "<date>"
    When the adjusted_cost committee is calculated
    Then the committee should have used quorum "from cost and date"
    And the conclusion of the committee should be <adjusted_cost>
    Examples:
      | cost   | date       | adjusted_cost |
      | 831.23 | 2010-08-01 |        831.23 |
      |  11.00 | 2005-07-14 |          11.0 |

  Scenario Outline: Adjusted cost committee from purchase amount and date
    Given a purchase emitter
    And a characteristic "purchase_amount" of "<amount>"
    And characteristic "date" of "<date>"
    When the adjusted_cost committee is calculated
    Then the committee should have used quorum "from purchase amount and date"
    And the conclusion of the committee should be <adjusted_cost>
    Examples:
      | amount | date       | adjusted_cost |
      | 831.23 | 2010-08-01 |       748.107 |
      |  11.00 | 2005-07-14 |           9.9 |

  Scenario Outline: Industry shares committee
    Given a purchase emitter
    And a characteristic "merchant_category.description" of "<merchant_category>"
    When the merchant_category committee is calculated
    And the industry_shares committee is calculated
    Then the conclusion of the committee should include a key of <naics> and value <ratio>
    Examples:
      | merchant_category | naics  | ratio |
      | Electronics shops | 443112 |   1.0 |

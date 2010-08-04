Feature: Purchase Committee Calculations
  The purchase model should generate correct committee calculations

  Scenario Outline: Adjusted cost committee from cost and date
    Given a purchase emitter deciding on sector emissions
    And a characteristic "cost" of "<cost>"
    And characteristic "date" of "<date>"
    When the "adjusted_cost" committee is calculated
    Then the committee should have used quorum "from cost and date"
    And the conclusion of the committee should be "<adjusted_cost>"
    Examples:
      | cost   | date       | adjusted_cost |
      | 831.23 | 2010-08-01 |        831.23 |
      |  11.00 | 2005-07-14 |          11.0 |

  Scenario Outline: Adjusted cost committee from purchase amount and date
    Given a purchase emitter deciding on sector emissions
    And a characteristic "purchase_amount" of "<amount>"
    And characteristic "date" of "<date>"
    When the "adjusted_cost" committee is calculated
    Then the committee should have used quorum "from purchase amount and date"
    And the conclusion of the committee should be "<adjusted_cost>"
    Examples:
      | amount | date       | adjusted_cost |
      | 831.23 | 2010-08-01 |       748.107 |
      |  11.00 | 2005-07-14 |           9.9 |

  Scenario Outline: Merchant category committee from merchant
    Given a purchase emitter deciding on sector emissions
    And a characteristic "merchant.id" of "<id>"
    When the "merchant_category" committee is calculated
    Then the conclusion of the committee should have "mcc" of "<mcc>"
    Examples:
      | id | mcc  |
      | 1  | 5111 |
      | 2  | 5732 |

  Scenario Outline: Industry shares committee from merchant category
    Given a purchase emitter deciding on sector emissions
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<naics>" and having "ratio" of "<ratio>"
    Examples:
      | mcc  | naics  | ratio  |
      | 5111 | 45321  |   1.0  |
      | 5732 | 443112 |   1.0  |
      | 5172 | 32411  |   0.8  |
      | 5172 | 324121 |   0.05 |
      | 5172 | 324122 |   0.05 |
      | 5172 | 324191 |   0.05 |
      | 5172 | 324199 |   0.05 |

  Scenario Outline: Industry shares committee from industry
    Given a purchase emitter deciding on sector emissions
    And a characteristic "naics_codes" including "<naics>"
    When the "industry_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<naics>" and having "ratio" including "<ratio>"
    Examples:
      | naics        | ratio    |
      | 45321        |     1.0  |
      | 443112       |     1.0  |
      | 32411        |     0.8  |
      | 324121       |     0.05 |
      | 324122       |     0.05 |
      | 324191       |     0.05 |
      | 324199,45321 | 0.05,1.0 |

  Scenario Outline: Product line shares committee
    Given a purchase emitter deciding on sector emissions
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    Then the conclusion of the committee should include a key of <ps_code> and value <ratio>
    Examples:
      | mcc  | ps_code  | ratio  |
      | 5111 | 20370    |    0.6 |
      | 5732 | 20375    |    0.5 |
      | 5172 | 30860    |   0.32 |
      | 5172 | 30861    | 0.0225 |
      | 5172 | 30862    | 0.0175 |
      | 5172 | 30863    |  0.018 |
      | 5172 | 30864    |  0.019 |

  Scenario Outline: Sector shares committee from industry shares
    Given a purchase emitter deciding on sector emissions
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should include a key of "<io_code>" and subvalue "share" of "<share>" and subvalue "emission_factor" of "<emission_factor>"
    Examples:
      | mcc  | io_code | emission_factor | share  |
      | 5111 |         |                 |        |
      | 5732 |         |                 |        |
      | 5172 | 324110  |             2.0 |    0.8 |
      | 5172 | 324121  |             1.3 |   0.05 |
      | 5172 | 324122  |             0.9 |   0.05 |
      | 5172 | 324191  |             0.2 |   0.05 |
      | 5172 | 324199  |             1.2 |   0.05 |

  Scenario Outline: Sector shares committee from industry shares and product line shares
    Given a purchase emitter deciding on sector emissions
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should include a key of "<io_code>" and subvalue "share" of "<share>" and subvalue "emission_factor" of "<emission_factor>"
    Examples:
      | mcc  | io_code | emission_factor | share  |
      | 5111 | 334111  |             1.3 |   0.24 |
      | 5111 | 33411A  |             0.5 |   0.18 |
      | 5111 | 511200  |             1.0 |   0.18 |
      | 5111 | 339940  |             1.1 |    0.2 |
      | 5111 | 322230  |             1.4 |    0.2 |
      | 5732 | 33411A  |             0.5 |    0.5 |
      | 5732 | 334300  |             1.2 |   0.25 |
      | 5732 | 334210  |             1.6 |    0.2 |
      | 5172 | 324110  |             2.0 |  0.256 |
      | 5172 | 324121  |             1.3 |   0.05 |
      | 5172 | 324122  |             0.9 |   0.05 |
      | 5172 | 324191  |             0.2 |   0.32 |
      | 5172 | 324199  |             1.2 |   0.05 |
      | 8225 | 722000  |             0.8 |   0.15 |

  Scenario Outline: Emission factor from sector shares
    Given a purchase emitter deciding on sector emissions
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "sector_shares" committee is calculated
    And the "emission_factor" committee is calculated
    Then the conclusion of the committee should be "<emission_factor>"
    Examples:
      | mcc  | emission_factor |
      | 5111 |           1.082 |
      | 5732 |            0.87 |
      | 5172 |        0.799205 |
      | 8225 |            0.12 |

  Scenario Outline: Emission factor from default
    Given a purchase emitter deciding on sector emissions
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "emission_factor" committee is calculated
    Then the conclusion of the committee should be "100"

Feature: Purchase Committee Calculations
  The purchase model should generate correct committee calculations

  Scenario Outline: Adjusted cost committee from cost and date
    Given a purchase emitter 
    And a characteristic "cost" of "<cost>"
    And characteristic "date" of "<date>"
    When the "adjusted_cost" committee is calculated
    Then the committee should have used quorum "from cost and date"
    And the conclusion of the committee should be "<adjusted_cost>"
    Examples:
      | cost   | date       | adjusted_cost |
      | 831.23 | 2010-08-01 |     688.67439 |
      |  11.00 | 2005-07-14 |       9.11350 |

  Scenario Outline: Adjusted cost committee from purchase amount and date
    Given a purchase emitter 
    And a characteristic "purchase_amount" of "<amount>"
    And characteristic "date" of "<date>"
    When the "cost" committee is calculated
    And the "adjusted_cost" committee is calculated
    Then the committee should have used quorum "from cost and date"
    And the conclusion of the committee should be "<adjusted_cost>"
    Examples:
      | amount | date       | adjusted_cost |
      | 831.23 | 2010-08-01 |     619.80695 |
      |  11.00 | 2005-07-14 |       8.20215 |

  Scenario Outline: Merchant category committee from merchant
    Given a purchase emitter 
    And a characteristic "merchant.id" of "<id>"
    When the "merchant_category" committee is calculated
    Then the conclusion of the committee should have "mcc" of "<mcc>"
    Examples:
      | id | mcc  |
      | 1  | 5111 |
      | 2  | 5732 |

  Scenario Outline: Industry shares committee from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<naics>" and having "ratio" of "<share>"
    Examples:
      | mcc  | naics  | share |
      | 5111 | 45321  | 1.0   |
      | 5172 | 32411  | 0.8   |
      | 5172 | 324121 | 0.05  |
      | 5172 | 324122 | 0.05  |
      | 5172 | 324191 | 0.05  |
      | 5172 | 324199 | 0.05  |

  Scenario Outline: Product line shares committee from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "ps_code" of "<ps_code>" and having "ratio" of "<share>"
    Examples:
      | mcc  | ps_code  | share  |
      | 5111 | 20370    |    0.6 |
      | 5111 | 20852    |    0.2 |
      | 5111 | 20853    |    0.2 |

  Scenario Outline: Sector shares committee from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "emission_factor" of "<emission_factor>"
    And the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "share" of "<share>"
    Examples:
      | mcc  | io_code | emission_factor | share  |
      | 5111 | 334111  |             1.3 |   0.24 |
      | 5111 | 511200  |             1.0 |   0.18 |
      | 5111 | 33411A  |             0.5 |   0.18 |
      | 5111 | 322230  |             1.4 |   0.2  |
      | 5111 | 339940  |             1.1 |   0.2  |
      | 5732 | 334300  |             1.2 |   0.25 |
      | 5732 | 33411A  |             0.5 |   0.5  |
      | 5732 | 334210  |             1.6 |   0.2  |
      | 5812 | 722000  |             0.8 |   1.0  |
      | 5172 | 324110  |             2.0 |   0.8  |
      | 5172 | 324121  |             1.3 |   0.05 |
      | 5172 | 324122  |             0.9 |   0.05 |
      | 5172 | 324191  |             0.2 |   0.05 |
      | 5172 | 324199  |             1.2 |   0.05 |

  Scenario Outline: Emission factor from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "sector_shares" committee is calculated
    And the "emission_factors" committee is calculated
    Then the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "factor" of "<emission_factor_share>"
    Examples:
      | mcc  | io_code | emission_factor_share |
      | 5111 | 334111  |                 0.312 |
      | 5111 | 33411A  |                  0.09 |
      | 5111 | 511200  |                  0.18 |
      | 5111 | 339940  |                  0.22 |
      | 5111 | 322230  |                  0.28 |
      | 5732 | 33411A  |                  0.25 |
      | 5732 | 334300  |                   0.3 |
      | 5732 | 334210  |                  0.32 |
      | 5172 | 324110  |                   1.6 |
      | 5172 | 324121  |                 0.065 |
      | 5172 | 324122  |                 0.045 |
      | 5172 | 324191  |                  0.01 |
      | 5172 | 324199  |                  0.06 |
      | 5812 | 722000  |                   0.8 |

  Scenario: Emission factor from default
    Given a purchase emitter 
    When the "emission_factors" committee is calculated
    Then the conclusion of the committee should have a record identified with "io_code" of "0" and having "factor" of "1"

  Scenario Outline: Sector emissions from merchant id, cost, and date
    Given a purchase emitter
    And a characteristic "merchant.id" of "<merchant>"
    And a characteristic "cost" of "<cost>"
    And a characteristic "date" of "<date>"
    When the "adjusted_cost" committee is calculated
    And the "merchant_category" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "sector_shares" committee is calculated
    And the "emission_factors" committee is calculated
    And the "sector_emissions" committee is calculated
    Then the conclusion of the committee should include "<emission>"
    Examples:
      | merchant | io_code | cost   | date       | emission  |
      |        1 | 322230  | 100.00 | 2010-07-28 |  23.19801 |
      |        1 | 334111  | 100.00 | 2010-07-28 |  25.84921 |
      |        1 | 339940  | 100.00 | 2010-07-28 |  18.22701 |
      |        1 | 511200  | 100.00 | 2010-07-28 |  14.91301 |
      |        1 | 33411A  | 100.00 | 2010-07-28 |   7.45650 |
      |        2 | 334210  | 100.00 | 2010-07-28 |  26.51201 |
      |        2 | 334300  | 100.00 | 2010-07-28 |  24.85501 |
      |        2 | 33411A  | 100.00 | 2010-07-28 |  20.71251 |
      |        3 | 722000  | 100.00 | 2010-07-28 |  66.28003 |
      |        4 | 7211A0  | 100.00 | 2010-07-28 |  82.85004 |
      |        5 | 324110  | 100.00 | 2010-07-28 | 132.56007 |
      |        5 | 324121  | 100.00 | 2010-07-28 |   5.38525 |
      |        5 | 324122  | 100.00 | 2010-07-28 |   3.72825 |
      |        5 | 324191  | 100.00 | 2010-07-28 |   0.82850 |
      |        5 | 324199  | 100.00 | 2010-07-28 |   4.97100 |

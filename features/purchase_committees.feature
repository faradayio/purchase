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
      | mcc  | ps_code | share |
      | 5111 | 20340   | 0.084 |
      | 5111 | 20370   | 0.283 |
      | 5111 | 20440   | 0.006 |
      | 5111 | 20851   | 0.122 |
      | 5111 | 20852   | 0.145 |
      | 5111 | 20853   | 0.265 |
      | 5111 | 20854   | 0.071 |
      | 5111 | 29938   | 0.011 |
      | 5111 | 29979   | 0.013 |

  Scenario Outline: Sector shares committee from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "emission_factor" of "<emission_factor>"
    And the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "share" of "<share>"
    Examples:
      | mcc  | io_code | emission_factor | share    |
      | 5111 | 337212  | 0.544           | 0.084    |
      | 5111 | 334111  | 0.284           | 0.0566   |
      | 5111 | 334112  | 0.37            | 0.014716 |
      | 5111 | 33411A  | 0.362           | 0.01698  |
      | 5111 | 511200  | 0.101           | 0.194704 |
      | 5111 | 333315  | 0.623           | 0.001044 |
      | 5111 | 3259A0  | 1.08            | 0.004194 |
      | 5111 | 334300  | 0.549           | 0.000762 |
      | 5111 | 322230  | 0.81            | 0.122    |
      | 5111 | 322230  | 0.81            | 0.145    |
      | 5111 | 322230  | 0.81            | 0.077645 |
      | 5111 | 339940  | 0.535           | 0.078175 |
      | 5111 | 325910  | 1.2             | 0.10918  |
      | 5111 | 33331A  | 0.567           | 0.002556 |
      | 5111 | 333315  | 0.623           | 0.002201 |
      | 5111 | 334111  | 0.284           | 0.0426   |
      | 5111 | 334112  | 0.37            | 0.011005 |
      | 5111 | 33411A  | 0.362           | 0.012638 |
      | 5111 | 323110  | 0.546           | 0.010505 |
      | 5111 | 323120  | 0.358           | 0.000495 |
      | 5111 | 532400  | 0.245           | 0.004251 |
      | 5111 | 812900  | 0.22            | 0.001599 |
      | 5111 | 532A00  | 0.23            | 0.001755 |
      | 5111 | 561400  | 0.186           | 0.005395 |
      | 5732 | 334300  | 0.549           | 0.25     |
      | 5732 | 33411A  | 0.362           | 0.5      |
      | 5732 | 334210  | 1.6             | 0.2      |
      | 5812 | 722000  | 0.8             | 1        |
      | 3504 | 7211A0  | 0.559           | 1        |
      | 5172 | 324110  | 2               | 0.8      |
      | 5172 | 324121  | 1.3             | 0.05     |
      | 5172 | 324122  | 0.9             | 0.05     |
      | 5172 | 324191  | 0.2             | 0.05     |
      | 5172 | 324199  | 1.2             | 0.05     |

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
      | 5111 | 337212  | 0.045696              |
      | 5111 | 334111  | 0.0160744             |
      | 5111 | 334112  | 0.00544492            |
      | 5111 | 33411A  | 0.00614676            |
      | 5111 | 511200  | 0.019665104           |
      | 5111 | 333315  | 0.000650412           |
      | 5111 | 3259A0  | 0.00452952            |
      | 5111 | 334300  | 0.000418338           |
      | 5111 | 322230  | 0.09882               |
      | 5111 | 322230  | 0.11745               |
      | 5111 | 322230  | 0.06289245            |
      | 5111 | 339940  | 0.041823625           |
      | 5111 | 325910  | 0.131016              |
      | 5111 | 33331A  | 0.001449252           |
      | 5111 | 333315  | 0.001371223           |
      | 5111 | 334111  | 0.0120984             |
      | 5111 | 334112  | 0.00407185            |
      | 5111 | 33411A  | 0.004574956           |
      | 5111 | 323110  | 0.00573573            |
      | 5111 | 323120  | 0.00017721            |
      | 5111 | 532400  | 0.001041495           |
      | 5111 | 812900  | 0.00035178            |
      | 5111 | 532A00  | 0.00040365            |
      | 5111 | 561400  | 0.00100347            |
      | 5732 | 334300  | 0.13725               |
      | 5732 | 33411A  | 0.181                 |
      | 5732 | 334210  | 0.32                  |
      | 5812 | 722000  | 0.8                   |
      | 3504 | 7211A0  | 0.559                 |
      | 5172 | 324110  | 1.6                   |
      | 5172 | 324121  | 0.065                 |
      | 5172 | 324122  | 0.045                 |
      | 5172 | 324191  | 0.01                  |
      | 5172 | 324199  | 0.06                  |

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
      | merchant | io_code | cost   | date       | emission |
      |        1 | 337212  | 100.00 | 2010-07-28 |   3.79   |
      |        1 | 334111  | 100.00 | 2010-07-28 |   1.33   |
      |        1 | 334112  | 100.00 | 2010-07-28 |   0.45   |
      |        1 | 33411A  | 100.00 | 2010-07-28 |   0.51   |
      |        1 | 511200  | 100.00 | 2010-07-28 |   1.63   |
      |        1 | 333315  | 100.00 | 2010-07-28 |   0.05   |
      |        1 | 3259A0  | 100.00 | 2010-07-28 |   0.38   |
      |        1 | 334300  | 100.00 | 2010-07-28 |   0.03   |
      |        1 | 322230  | 100.00 | 2010-07-28 |   8.19   |
      |        1 | 322230  | 100.00 | 2010-07-28 |   9.73   |
      |        1 | 322230  | 100.00 | 2010-07-28 |   5.21   |
      |        1 | 339940  | 100.00 | 2010-07-28 |   3.47   |
      |        1 | 325910  | 100.00 | 2010-07-28 |  10.85   |
      |        1 | 33331A  | 100.00 | 2010-07-28 |   0.12   |
      |        1 | 333315  | 100.00 | 2010-07-28 |   0.11   |
      |        1 | 334111  | 100.00 | 2010-07-28 |   1.00   |
      |        1 | 334112  | 100.00 | 2010-07-28 |   0.34   |
      |        1 | 33411A  | 100.00 | 2010-07-28 |   0.38   |
      |        1 | 323110  | 100.00 | 2010-07-28 |   0.48   |
      |        1 | 323120  | 100.00 | 2010-07-28 |   0.01   |
      |        1 | 532400  | 100.00 | 2010-07-28 |   0.09   |
      |        1 | 812900  | 100.00 | 2010-07-28 |   0.03   |
      |        1 | 532A00  | 100.00 | 2010-07-28 |   0.03   |
      |        1 | 561400  | 100.00 | 2010-07-28 |   0.08   |
      |        2 | 334300  | 100.00 | 2010-07-28 |  11.37   |
      |        2 | 33411A  | 100.00 | 2010-07-28 |  15.00   |
      |        2 | 334210  | 100.00 | 2010-07-28 |  26.51   |
      |        3 | 722000  | 100.00 | 2010-07-28 |  66.28   |
      |        4 | 7211A0  | 100.00 | 2010-07-28 |  46.31   |
      |        5 | 324110  | 100.00 | 2010-07-28 | 132.56   |
      |        5 | 324121  | 100.00 | 2010-07-28 |   5.39   |
      |        5 | 324122  | 100.00 | 2010-07-28 |   3.73   |
      |        5 | 324191  | 100.00 | 2010-07-28 |   0.83   |
      |        5 | 324199  | 100.00 | 2010-07-28 |   4.97   |

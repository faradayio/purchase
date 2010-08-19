Feature: Purchase Committee Calculations
  The purchase model should generate correct committee calculations

  Scenario Outline: Cost committee from purchase amount
    Given a purchase emitter 
    And a characteristic "purchase_amount" of "<amount>"
    When the "cost" committee is calculated
    Then the conclusion of the committee should be "<cost>"
    Examples:
      | amount | cost    |
      | 831.23 | 748.107 |
      |  11.00 |   9.9   |

  Scenario Outline: Cost committee from purchase amount and tax
    Given a purchase emitter
    And a characteristic "purchase_amount" of "<amount>"
    And a characteristic "tax" of "<tax>"
    When the "cost" committee is calculated
    Then the conclusion of the committee should be "<cost>"
    Examples:
      | amount | tax  | cost |
      | 10.00  | 1.00 | 9.00 |

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
    Then the conclusion of the committee should be a vector with value "<share>" and position for key "<io_code>"
    Examples:
      | mcc  | io_code | share       |
      | 3504 | 19      | 0.559       | 
      | 5111 | 1       | 0.27916245  | 
      | 5111 | 3       | 0.00573573  | 
      | 5111 | 4       | 0.041823625 | 
      | 5111 | 5       | 0.000650412 | 
      | 5111 | 6       | 0.002021635 | 
      | 5111 | 7       | 0.131016    | 
      | 5111 | 8       | 0.016074    |
      | 5111 | 9       | 0.005444    |
      | 5111 | 10      | 0.006146    | 
      | 5111 | 11      | 0.001041495 | 
      | 5111 | 12      | 0.00452952  | 
      | 5111 | 13      | 0.045696    |
      | 5111 | 14      | 0.06289245  | 
      | 5111 | 15      | 0.00614676  | 
      | 5111 | 16      | 0.00017721  | 
      | 5111 | 17      | 0.00035178  | 
      | 5111 | 18      | 0.00040365  | 
      | 5172 | 20      | 1.6         | 
      | 5172 | 21      | 0.065       | 
      | 5172 | 22      | 0.045       | 
      | 5172 | 23      | 0.01        | 
      | 5172 | 24      | 0.06        | 
      | 5732 | 10      | 0.181       | 
      | 5732 | 12      | 0.13725     | 
      | 5732 | 25      | 0.32        | 
      | 5812 | 26      | 0.8         | 

  Scenario Outline: Economic flows from merchant category code
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "sector_shares" committee is calculated
    And the "emission_factors" committee is calculated
    Then the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "factor" of "<emission_factor_share>"
    Examples:
      | mcc  | io_code | emission_factor_share |
      | 3504 | 19      | 0.559                 |
      | 5111 | 1       | 0.06289245            |
      | 5111 | 3       | 0.00017721            |
      | 5111 | 4       | 0.131016              |
      | 5111 | 5       | 0.01052952            |
      | 5111 | 6       | 0.000650412           |
      | 5111 | 6       | 0.001371223           |
      | 5111 | 7       | 0.001449252           |
      | 5111 | 8       | 0.0120984             |
      | 5111 | 8       | 0.0160744             |
      | 5111 | 9       | 0.00407185            |
      | 5111 | 9       | 0.00544492            |
      | 5111 | 10      | 0.004574956           |
      | 5111 | 10      | 0.00614676            |
      | 5111 | 11      | 0.00035178            |
      | 5111 | 12      | 0.000418338           |
      | 5111 | 13      | 0.045696              |
      | 5111 | 14      | 0.041823625           |
      | 5111 | 15      | 0.019665104           |
      | 5111 | 16      | 0.001041495           |
      | 5111 | 17      | 0.00040365            |
      | 5111 | 18      | 0.00100347            |
      | 5172 | 20      | 1.6                   |
      | 5172 | 21      | 0.065                 |
      | 5172 | 22      | 0.045                 |
      | 5172 | 23      | 0.01                  |
      | 5172 | 24      | 0.06                  |
      | 5732 | 10      | 0.181                 |
      | 5732 | 12      | 0.13725               |
      | 5732 | 25      | 0.32                  |
      | 5812 | 26      | 0.8                   |

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
      |        1 | 1       | 100.00 | 2010-07-28 |   0.48   |
      |        1 | 1       | 100.00 | 2010-07-28 |   5.21   |
      |        1 | 1       | 100.00 | 2010-07-28 |   8.19   |
      |        1 | 1       | 100.00 | 2010-07-28 |   9.73   |
      |        1 | 3       | 100.00 | 2010-07-28 |   0.01   |
      |        1 | 4       | 100.00 | 2010-07-28 |  10.85   |
      |        1 | 5       | 100.00 | 2010-07-28 |   0.38   |
      |        1 | 6       | 100.00 | 2010-07-28 |   0.05   |
      |        1 | 6       | 100.00 | 2010-07-28 |   0.11   |
      |        1 | 7       | 100.00 | 2010-07-28 |   0.12   |
      |        1 | 8       | 100.00 | 2010-07-28 |   1.00   |
      |        1 | 8       | 100.00 | 2010-07-28 |   1.33   |
      |        1 | 9       | 100.00 | 2010-07-28 |   0.34   |
      |        1 | 9       | 100.00 | 2010-07-28 |   0.45   |
      |        1 | 10      | 100.00 | 2010-07-28 |   0.38   |
      |        1 | 10      | 100.00 | 2010-07-28 |   0.51   |
      |        1 | 11      | 100.00 | 2010-07-28 |   0.03   |
      |        1 | 12      | 100.00 | 2010-07-28 |   0.03   |
      |        1 | 13      | 100.00 | 2010-07-28 |   3.79   |
      |        1 | 14      | 100.00 | 2010-07-28 |   3.47   |
      |        1 | 15      | 100.00 | 2010-07-28 |   1.63   |
      |        1 | 16      | 100.00 | 2010-07-28 |   0.09   |
      |        1 | 17      | 100.00 | 2010-07-28 |   0.03   |
      |        1 | 18      | 100.00 | 2010-07-28 |   0.08   |
      |        2 | 10      | 100.00 | 2010-07-28 |  15.00   |
      |        2 | 12      | 100.00 | 2010-07-28 |  11.37   |
      |        2 | 25      | 100.00 | 2010-07-28 |  26.51   |
      |        3 | 26      | 100.00 | 2010-07-28 |  66.28   |
      |        4 | 19      | 100.00 | 2010-07-28 |  46.31   |
      |        5 | 20      | 100.00 | 2010-07-28 | 132.56   |
      |        5 | 21      | 100.00 | 2010-07-28 |   5.39   |
      |        5 | 22      | 100.00 | 2010-07-28 |   3.73   |
      |        5 | 23      | 100.00 | 2010-07-28 |   0.83   |
      |        5 | 24      | 100.00 | 2010-07-28 |   4.97   |

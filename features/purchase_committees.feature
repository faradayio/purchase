Feature: Purchase Committee Calculations
  The purchase model should generate correct committee calculations

  Scenario: Cost committee from purchase amount
    Given a purchase emitter
    And a characteristic "purchase_amount" of "107.11"
    When the "cost" committee is calculated
    Then the committee should have used quorum "from purchase amount"
    And the conclusion of the committee should be "100"

  Scenario: Cost committee from purchase amount and tax
    Given a purchase emitter
    And a characteristic "purchase_amount" of "10.00"
    And a characteristic "tax" of "1.00"
    When the "cost" committee is calculated
    Then the committee should have used quorum "from purchase amount and tax"
    And the conclusion of the committee should be "9.00"

  Scenario: Cost committee from default
    Given a purchase emitter
    When the "cost" committee is calculated
    Then the conclusion of the committee should be "100"

  Scenario Outline: Adjusted cost committee from cost and date
    Given a purchase emitter
    And a characteristic "cost" of "<cost>"
    And characteristic "date" of "<date>"
    When the "adjusted_cost" committee is calculated
    Then the conclusion of the committee should be "<adjusted_cost>"
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
      | 1  | 1111 |
      | 2  | 2222 |

  Scenario: Merchant category committee from default
    Given a purchase emitter
    When the "merchant_category" committee is calculated
    Then the conclusion of the committee should have "mcc" of "5111"

  Scenario Outline: Merchant category industries committee from merchant category
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_category_industries" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<naics>" and having "ratio" of "<ratio>"
    Examples:
      | mcc  | naics  | ratio |
      | 1111 | 111111 | 1     |
      | 2222 | 399900 | 0.5   |
      | 2222 | 459000 | 0.5   |

  Scenario Outline: Industry shares committee
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_category_industries" committee is calculated
    And the "industry_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<naics>" and having "ratio" of "<share>"
    Examples:
      | mcc  | naics  | share |
      | 1111 | 111111 | 1.0   |
      | 2222 | 399900 | 0.5   |
      | 2222 | 459000 | 0.5   |

  Scenario Outline: Product line shares committee from industry
    Given a purchase emitter
    And a characteristic "naics_code" of "<naics>"
    When the "product_line_shares" committee is calculated
    Then the committee should have used quorum "from industry"
    And the conclusion of the committee should have a record identified with "ps_code" of "<ps_code>" and having "ratio" of "<share>"
    Examples:
      | naics  | ps_code | share |
      | 111111 |         |       |
      | 459000 | 45911   | 0.75  |
      | 459000 | 45912   | 0.25  |

  Scenario Outline: Product line shares committee from merchant category
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_category_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "ps_code" of "<ps_code>" and having "ratio" of "<share>"
    Examples:
      | mcc  | ps_code | share |
      | 1111 |         |       |
      | 2222 | 45911   | 0.375 |
      | 2222 | 45912   | 0.125 |

  Scenario Outline: Industry sectors committee from industry
    Given a purchase emitter
    And a characteristic "naics_code" of "<naics>"
    When the "industry_sectors" committee is calculated
    Then the committee should have used quorum "from industry"
    And the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "ratio" of "<share>"
    Examples:
      | naics  | io_code | share |
      | 111111 | 111000  | 1.0   |
      | 399100 | 3991A0  | 0.75  |
      | 399100 | 3991B0  | 0.25  |
      | 399200 | 399200  | 1.0   |
      | 399900 | 399900  | 1.0   |
      | 459000 | 4A0000  | 1.0   |

  Scenario Outline: Industries sectors committee from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "cost" of "100"
    And a characteristic "date" of "2010-08-01"
    When the "adjusted_cost" committee is calculated
    And the "merchant_category_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "industry_sectors" committee is calculated
    Then the committee should have used quorum "from industry shares"
    And the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "ratio" of "<share>"
    Examples:
      | mcc  | io_code  | share |
      | 1111 | 111000   | 1.0   |
      | 2222 | 399900   | 0.5   |
      | 2222 | 4A0000   | 0.5   |

  Scenario Outline: Sector shares committee from industry and product line shares
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "adjusted_cost" of "1"
    When the "merchant_category_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "industry_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should be a vector with values "<1>,<10>,<11>,<12>,<13>,<14>,<15>,<16>,<17>,<18>,<19>,<2>,<20>,<21>,<22>,<23>,<24>,<25>,<26>,<3>,<4>,<44100>,<44102>,<44103>,<44104>,<44105>,<5>,<6>,<7>,<8>,<9>,<A>,<B>,<C>,<D>"
    Examples:
      | mcc|1|10|11|12|13|14|15|16|17|18|19|2|20|21|22|23|24|25| 26|3|4|44100|44102|44103|44104|44105|5|6|7|8|9|     A|     B|     C|     D|
      |5812|0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0|0| 0| 0| 0| 0| 0| 0|1.0|0|0|    0|    0|    0|    0|    0|0|0|0|0|0|     0|     0|     0|     0|
      |9999|0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0|0| 0| 0| 0| 0| 0| 0|  0|0|0|    0|    0|    0|    0|    0|0|0|0|0|0|0.1875|0.1875|0.0625|0.0625|

  Scenario: Sector direct requirements
    Given a purchase emitter
    When the "sector_direct_requirements" committee is calculated
    Then the conclusion of the committee should be a square matrix with "35" rows and columns

  Scenario: Economic flows from merchant category
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "5812"
    And a characteristic "date" of "2010-08-01"
    And a characteristic "cost" of "100"
    When the "adjusted_cost" committee is calculated
    And the "merchant_category_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "industry_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    And the "sector_direct_requirements" committee is calculated
    And the "economic_flows" committee is calculated
    Then the conclusion of the committee should be a vector with "35" items

  Scenario Outline: Impacts committee from economic flows
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "date" of "2010-08-01"
    And a characteristic "cost" of "100"
    When the "adjusted_cost" committee is calculated
    And the "merchant_category_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "industry_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    And the "sector_direct_requirements" committee is calculated
    And the "economic_flows" committee is calculated
    And the "impact_vectors" committee is calculated
    And the "impacts" committee is calculated
    Then the conclusion of the committee should be a vector with values "<1>,<10>,<11>,<12>,<13>,<14>,<15>,<16>,<17>,<18>,<19>,<2>,<20>,<21>,<22>,<23>,<24>,<25>,<26>,<3>,<4>,<44100>,<44102>,<44103>,<44104>,<44105>,<5>,<6>,<7>,<8>,<9>,<A>,<B>,<C>,<D>"
    Examples:
      | mcc|1|10|11|12|13|14|15|16|17|18|19|2|20|21|22|23|24|25| 26|3|4|44100|44102|44103|44104|44105|5|6|7|8|9|     A|     B|     C|     D|
      |3504| 34.20759 | 22.83238 | 21.58704 | 71.66304 | 75.34399 | 43.05229 | 44.19605 | 24.59386 | 31.74734 | 34.23285 | 38.90812 | 50.97981 | 42.48382 | 38.68232 | 7.06766 | 14.44985 | 11.89899 | 7.95409 | 24.56535 | 75.44609 | 41.91640 | 21.38395 | 3.61236 | 20.87780 | 20.49698 | 5.33446 | 0.28203 | 2.65319 | 3.94288 | 4.60106 | 71.40280 | 24.44457 | 24.44457 | 24.56517 | 21.88041 |
      |5111| 43.11882 | 14.80914 | 11.03291 | 36.54622 | 46.29633 | 26.17054 | 32.10542 | 13.52681 | 17.39109 | 19.28008 | 12.79735 | 29.46601 | 26.80161 | 25.34407 | 4.74774 | 9.84523 | 8.12740 | 5.76849 | 17.87935 | 55.05595 | 39.96103 | 15.46327 | 2.35871 | 13.67770 | 13.18761 | 4.14058 | 2.01647 | 4.80043 | 6.27992 | 12.36538 | 79.88824 | 27.42322 | 27.42322 | 27.48354 | 24.08718 |
      |5172| 35.58872 | 23.75424 | 19.71380 | 65.44441 | 70.92181 | 40.52542 | 46.99530 | 26.65128 | 34.40320 | 37.53618 | 24.68486 | 55.96723 | 82.58029 | 48.39434 | 8.55823 | 16.05688 | 13.17485 | 7.93908 | 24.20801 | 72.40388 | 39.79780 | 20.18866 | 3.40454 | 19.65695 | 19.28569 | 4.97658 | 0.23634 | 2.57416 | 3.79738 | 4.40459 | 68.84678 | 23.57193 | 23.57193 | 23.68206 | 20.88125 |
      |5732| 23.82496 | 38.07691 | 13.11535 | 67.43841 | 47.01503 | 26.86485 | 28.54448 | 16.48957 | 21.28581 | 23.75176 | 16.05288 | 36.48537 | 34.13793 | 33.78076 | 6.37445 | 13.50597 | 11.33464 | 10.34780 | 23.80141 | 71.08195 | 37.57537 | 19.56198 | 3.32479 | 19.24582 | 18.92542 | 4.96435 | 0.29751 | 2.39136 | 3.54334 | 4.20360 | 64.55618 | 22.09769 | 22.09769 | 22.17096 | 20.29572 |
      |5812| 34.59232 | 23.08918 | 19.48251 | 64.67657 | 70.88026 | 40.50168 | 43.64568 | 25.42384 | 32.81874 | 37.49322 | 25.83877 | 58.82688 | 56.29772 | 54.71279 | 11.61328 | 25.17174 | 21.33815 | 14.31873 | 81.35713 | 123.84802 | 53.98569 | 22.37338 | 3.51343 | 20.06660 | 19.35014 | 4.96561 | 0.24528 | 2.52186 | 3.73916 | 4.34106 | 67.67328 | 23.16928 | 23.16928 | 23.27813 | 20.55662 |

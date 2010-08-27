Feature: Purchase Committee Calculations
  The purchase model should generate correct committee calculations

  Scenario Outline: Cost committee from purchase amount
    Given a purchase emitter 
    And a characteristic "purchase_amount" of "<amount>"
    When the "cost" committee is calculated
    Then the committee should have used quorum "from purchase amount"
    And the conclusion of the committee should be "<cost>"
    Examples:
      | amount | cost    |
      | 831.23 | 748.107 |
      |  11.00 |   9.9   |

  Scenario Outline: Cost committee from purchase amount and tax
    Given a purchase emitter
    And a characteristic "purchase_amount" of "<amount>"
    And a characteristic "tax" of "<tax>"
    When the "cost" committee is calculated
    Then the committee should have used quorum "from purchase amount and tax"
    And the conclusion of the committee should be "<cost>"
    Examples:
      | amount | tax  | cost |
      | 10.00  | 1.00 | 9.00 |

  Scenario Outline: Adjusted cost committee
    Given a purchase emitter 
    And a characteristic "cost" of "<cost>"
    And characteristic "date" of "<date>"
    When the "adjusted_cost" committee is calculated
    Then the conclusion of the committee should be "<adjusted_cost>"
    Examples:
      | cost   | date       | adjusted_cost |
      | 831.23 | 2010-08-01 |     688.67439 |
      |  11.00 | 2005-07-14 |       9.11350 |

  Scenario Outline: Merchant category committee
    Given a purchase emitter 
    And a characteristic "merchant.id" of "<id>"
    When the "merchant_category" committee is calculated
    Then the conclusion of the committee should have "mcc" of "<mcc>"
    Examples:
      | id | mcc  |
      | 1  | 5111 |
      | 2  | 5732 |
      | 9  | 9999 |

  Scenario Outline: Merchant categories industries committee
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_categories_industries" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<naics>" and having "ratio" of "<ratio>"
    Examples:
      | mcc  | naics  | ratio |
      | 3504 | 72111  | 1     |
      | 5111 | 45321  | 1     |
      | 5172 | 32411  | 0.8   |
      | 5172 | 324121 | 0.05  |
      | 5172 | 324122 | 0.05  |
      | 5172 | 324191 | 0.05  |
      | 5172 | 324199 | 0.05  |
      | 5732 | 443112 | 1     |
      | 5812 | 72211  | 1     |
      | 9999 | 999991 | 0.5   |
      | 9999 | 999992 | 0.5   |

  Scenario Outline: Industry shares committee
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_categories_industries" committee is calculated
    And the "industry_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<naics>" and having "ratio" of "<share>"
    Examples:
      | mcc  | naics  | share |
      | 5111 | 45321  | 1.0   |
      | 5172 | 32411  | 0.8   |
      | 5172 | 324121 | 0.05  |
      | 5172 | 324122 | 0.05  |
      | 5172 | 324191 | 0.05  |
      | 5172 | 324199 | 0.05  |
      | 9999 | 999991 | 0.5   |
      | 9999 | 999992 | 0.5   |

  Scenario Outline: Product line shares committee from industry
    Given a purchase emitter 
    And a characteristic "industry.naics_code" of "<naics>"
    When the "product_line_shares" committee is calculated
    Then the committee should have used quorum "from industry"
    And the conclusion of the committee should have a record identified with "ps_code" of "<ps_code>" and having "ratio" of "<share>"
    Examples:
      | naics  | ps_code | share |
      | 45321  | 20370   | 0.283 |
      | 45321  | 20853   | 0.265 |
      | 45321  | 20852   | 0.145 |
      | 45321  | 20851   | 0.122 |
      | 45321  | 20340   | 0.084 |
      | 45321  | 20854   | 0.071 |
      | 45321  | 29979   | 0.013 |
      | 45321  | 29938   | 0.011 |
      | 45321  | 20440   | 0.006 |
      | 999992 | 99992   | 0.75  |
      | 999992 | 99993   | 0.25  |

  Scenario Outline: Product line shares committee from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_categories_industries" committee is calculated
    And the "industry_shares" committee is calculated
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
      | 9999 | 99992   | 0.375 |
      | 9999 | 99993   | 0.125 |

  Scenario Outline: Industries sectors committee from industry
    Given a purchase emitter 
    And a characteristic "industry.naics_code" of "<naics>"
    When the "industries_sectors" committee is calculated
    Then the committee should have used quorum "from industry"
    And the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "ratio" of "<share>"
    Examples:
      | naics  | io_code | share |
      | 45321  | 4A0000  | 1.0   |
      | 443112 | 4A0000  | 1.0   |
      | 999991 | 99999A  | 0.75  |
      | 999991 | 99999B  | 0.25  |
      | 999992 | 4A0000  | 1.00  |

    Scenario Outline: Industries sectors committee from merchant category
      Given a purchase emitter 
      And a characteristic "merchant_category.mcc" of "<mcc>"
      When the "merchant_categories_industries" committee is calculated
      And the "industry_shares" committee is calculated
      And the "industries_sectors" committee is calculated
      Then the committee should have used quorum "from industry shares"
      And the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "ratio" of "<share>"
      Examples:
        | mcc  | io_code  | share |
        | 3504 | 19       | 1.0   |
        | 5111 | 4A0000   | 1.0   |
        | 5172 | 20       | 0.8   |
        | 5172 | 21       | 0.05  |
        | 5172 | 22       | 0.05  |
        | 5172 | 23       | 0.05  |
        | 5172 | 24       | 0.05  |
        | 5732 | 4A0000   | 1.0   |
        | 5812 | 26       | 1.0   |
        | 9999 | 999991   | 0.5   |
        | 9999 | 999992   | 0.5   |

  Scenario Outline: Sector shares committee from industry and product line shares
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_categories_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "industries_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should be a vector with values "<1>,<2>,<3>,<4>,<5>,<6>,<7>,<8>,<9>,<10>,<11>,<12>,<13>,<14>,<15>,<16>,<17>,<18>,<19>,<20>,<21>,<22>,<23>,<24>,<25>,<26>,<44100>,<44101>,<44102>,<44103>,<44104>,<44105>"
    Examples:
    |mcc |         1|         2|         3|          4|          5|          6|          7|        8|         9|         10|        11|         12|      13|         14|         15|         16|        17|        18|   19| 20|   21|   22|  23|  24|  25| 26|44100|44101|44102|44103|44104|44105|
    |3504|         0|         0|         0|          0|          0|          0|          0|        0|         0|          0|         0|          0|       0|          0|          0|          0|         0|         0|0.559|  0|    0|    0|   0|   0|   0|  0|    0|    0|    0|    0|    0|    0|
    |5111|0.27916245|0.00573573|0.00017721| 0.13101600| 0.00452952|0.002021635|0.001449252|0.0281728|0.00951677|0.010721716|0.00035178|0.000418338|0.045696|0.041823625|0.019665104|0.001041495|0.00040365|0.00100347|    0|  0|    0|    0|   0|   0|   0|  0|    0|    0|    0|    0|    0|    0|
    |5172|         0|         0|         0|          0|          0|          0|          0|        0|         0|          0|         0|          0|       0|          0|          0|          0|         0|         0|    0|1.6|0.065|0.045|0.01|0.06|   0|  0|    0|    0|    0|    0|    0|    0|
    |5732|         0|         0|         0|          0|          0|          0|          0|        0|         0|      0.181|         0|    0.13725|       0|          0|          0|          0|         0|         0|    0|  0|    0|    0|   0|   0|0.32|  0|    0|    0|    0|    0|    0|    0|
    |5812|         0|0|         0|          0|          0|          0|       0|       0|       0|       0|          0|         0|       0|         0|         0|         0|         0|         0|    0|  0|    0|    0|   0|   0|   0|0.8|    0|    0|    0|    0|    0|    0|

  Scenario Outline: Sector shares committee from industry
    Given a purchase emitter 
    And a characteristic "naics_code" of "<naics>"
    When the "sector_shares" committee is calculated
    Then the conclusion of the committee should be a vector with value "<share>" and position for key "<io_code>"
    Examples:
      | naics  | io_code | share       |
      | 32411  | 20      | 2           | 
      | 324121 | 21      | 1.3         | 
      | 324122 | 22      | 0.9         | 
      | 324191 | 23      | 0.2         | 
      | 324199 | 24      | 1.2         | 
      | 72111  | 19      | 0.559       |
      | 72211  | 26      | 0.8         |

  Scenario: Sector direct requirements
    Given a purchase emitter 
    When the "sector_direct_requirements" committee is calculated
    Then the conclusion of the committee should be a square matrix with "32" rows and columns

  Scenario Outline: Economic flows from merchant category code 3504
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "cost" of "100"
    When the "adjusted_cost" committee is calculated
    And the "merchant_categories_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "industries_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    And the "sector_direct_requirements" committee is calculated
    And the "economic_flows" committee is calculated
    Then the conclusion of the committee should be a vector with values "<1>,<2>,<3>,<4>,<5>,<6>,<7>,<8>,<9>,<10>,<11>,<12>,<13>,<14>,<15>,<16>,<17>,<18>,<19>,<20>,<21>,<22>,<23>,<24>,<25>,<26>,<44100>,<44101>,<44102>,<44103>,<44104>,<44105>"
    Examples:
      |mcc |1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|44100|44101|44102|44103|44104|44105|
      |3504|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|0.559|00|00|00|00|00|00|00|00000|00000|00000|00000|00000|00000|
      |5111|0.29365|0.06580|0.013337|0.19108|0.019023|0.06208|0.01594|0.08823|0.02401|0.07078|0.01484|0.06048|0.06018|0.10188|0.03415|0.06110|0.02100|0.06106|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|
      |5172|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|00|1.6|0.065|0.045|0.01|0.06|00|00|00000|00000|00000|00000|00000|00000|
      |5732|0|0|0|0|0|0|0|0|0|0.181|00|0.13725|00|00|00|00|00|00|00|00|00|00|00|00|0.32|00|00000|00000|00000|00000|00000|00000|
      |5812|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|0.8|00000|00000|00000|00000|00000|00000|
      |8225|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00000|00000|00000|00000|00000|00000|

  Scenario Outline: Impacts committee from economic flows
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "cost" of "100"
    When the "adjusted_cost" committee is calculated
    And the "merchant_categories_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "industries_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    And the "sector_direct_requirements" committee is calculated
    And the "economic_flows" committee is calculated
    And the "impact_vectors" committee is calculated
    And the "impacts" committee is calculated
    Then the conclusion of the committee should be a vector with values "<1>,<2>,<3>,<4>,<5>,<6>,<7>,<8>,<9>,<10>,<11>,<12>,<13>,<14>,<15>,<16>,<17>,<18>,<19>,<20>,<21>,<22>,<23>,<24>,<25>,<26>,<44100>,<44101>,<44102>,<44103>,<44104>,<44105>"
    Examples:
      |mcc |1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|44100|44101|44102|44103|44104|44105|
      |3504|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|1.0621|00|00|00|00|00|00|00|00000|00000|00000|00000|00000|00000|
      |5111|0.29365|0.13160|0.040012|0.76432|0.09511|0.37251|0.11160|0.70590|0.21609|0.07078|0.01633|0.07258|0.07824|0.14264|0.05123|0.09777|0.03570|0.10992|0.02753|0.12013|0.03043|0.13214|0.03333|0.14415|0.03623|0.15616|0.63918|0.26488|0.60888|2.06683|0.64410|3.24951|
      |5172|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|00|3.2|0.1365|0.099|0.023|0.144|00|00|00000|00000|00000|00000|00000|00000|
      |5732|0|0|0|0|0|0|0|0|0|0.181|00|0.13725|00|00|00|00|00|00|00|00|00|00|00|00|0.32|00|00000|00000|00000|00000|00000|00000|
      |5812|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|0.8|00000|00000|00000|00000|00000|00000|
      |8225|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00000|00000|00000|00000|00000|00000|

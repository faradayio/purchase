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
    Then the committee should have used quorum "default"
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

  Scenario Outline: Trade industry ratios from merchant category industries
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_category_industries" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    Then the committee should have used quorum "from merchant category industries"
    And the conclusion of the committee should include a key of "<naics>" and value "<ratio>"
    Examples:
      | mcc  | naics  | ratio |
      | 2222 | 459000 | 0.5   |

  Scenario Outline: Trade industry ratios from industry
    Given a purchase emitter
    And a characteristic "industry.naics_code" of "<naics>"
    When the "trade_industry_ratios" committee is calculated
    Then the committee should have used quorum "from naics code"
    And the conclusion of the committee should include a key of "<naics>" and value "1"
    Examples:
      | naics  |
      | 459000 |

  Scenario Outline: Non-trade industry ratios from merchant category industries
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_category_industries" committee is calculated
    And the "non_trade_industry_ratios" committee is calculated
    Then the committee should have used quorum "from merchant category industries"
    And the conclusion of the committee should include a key of "<naics>" and value "<ratio>"
    Examples:
      | mcc  | naics  | ratio |
      | 1111 | 111111 | 1     |
      | 2222 | 399900 | 0.5   |

  Scenario Outline: Non-trade industry ratios from industry
    Given a purchase emitter
    And a characteristic "industry.naics_code" of "<naics>"
    When the "non_trade_industry_ratios" committee is calculated
    Then the conclusion of the committee should include a key of "<naics>" and value "1"
    Examples:
      | naics  |
      | 111111 |
      | 399900 |

  Scenario Outline: Non-trade industry ratios from default
    Given a purchase emitter
    When the "non_trade_industry_ratios" committee is calculated
    Then the committee should have used quorum "from default"
    And the conclusion of the committee should include a key of "111111" and value "1"

  Scenario Outline: Product line ratios from trade industry ratios
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_category_industries" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    Then the conclusion of the committee should include a key of "<ps_code>" and value "<ratio>"
    Examples:
      | mcc  | ps_code | ratio |
      | 2222 | 45911   | 0.375 |
      | 2222 | 45912   | 0.125 |

  Scenario Outline: Product line industry product ratios from product line ratios
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_category_industries" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    Then the conclusion of the committee should include a key of "<naics_product_code>" and value "<ratio>"
    Examples:
      | mcc  | naics_product_code  | ratio  |
      | 2222 | 399100A             | 0.1875 |
      | 2222 | 399100B             | 0.1875 |
      | 2222 | 399200A             | 0.0625 |
      | 2222 | 399200B             | 0.0625 |

  Scenario Outline: Industry product ratios from product line industry product ratios
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_category_industries" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    And the "industry_product_ratios" committee is calculated
    Then the conclusion of the committee should include a key of "<naics>" and value "<ratio>"
    Examples:
      | mcc  | naics  | ratio  |
      | 2222 | 399100 | 0.1875 |
      | 2222 | 399200 | 0.0625 |

  Scenario Outline: Industry ratios committee from non trade industry and industry product ratios 
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_category_industries" committee is calculated
    And the "non_trade_industry_ratios" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    And the "industry_product_ratios" committee is calculated
    And the "industry_ratios" committee is calculated
    Then the conclusion of the committee should include a key of "<naics>" and value "<ratio>"
    Examples:
      | mcc  | naics  | ratio  |
      | 1111 | 111111 | 1.0    |
      | 2222 | 399100 | 0.1875 |
      | 2222 | 399200 | 0.0625 |
      | 2222 | 399900 | 0.5    |

  Scenario Outline: Industry ratios committee from industry
    Given a purchase emitter
    And a characteristic "industry.naics_code" of "<naics>"
    When the "non_trade_industry_ratios" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    And the "industry_product_ratios" committee is calculated
    And the "industry_ratios" committee is calculated
    Then the conclusion of the committee should include a key of "<new_naics>" and value "<ratio>"
    Examples:
      | naics  | new_naics | ratio |
      | 111111 | 111111    | 1.0   |
      | 459000 | 399100    | 0.375 |
      | 459000 | 399200    | 0.125 |
      | 399900 | 399900    | 1.0   |

  Scenario Outline: Industry sector ratios committee from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "cost" of "100"
    And a characteristic "date" of "2010-08-01"
    When the "merchant_category_industries" committee is calculated
    And the "non_trade_industry_ratios" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    And the "industry_product_ratios" committee is calculated
    And the "industry_ratios" committee is calculated
    And the "industry_sector_ratios" committee is calculated
    Then the conclusion of the committee should include a key of "<io_code>" and value "<ratio>"
    Examples:
      | mcc  | io_code | ratio    |
      | 1111 | 111000  | 1.0      |
      | 2222 | 3991A0  | 0.140625 |
      | 2222 | 3991B0  | 0.046875 |
      | 2222 | 399200  | 0.0625   |
      | 2222 | 399900  | 0.5      |

  Scenario Outline: Industry sector ratios committee from industry
    Given a purchase emitter
    And a characteristic "industry.naics_code" of "<naics>"
    When the "non_trade_industry_ratios" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    And the "industry_product_ratios" committee is calculated
    And the "industry_ratios" committee is calculated
    And the "industry_sector_ratios" committee is calculated
    Then the conclusion of the committee should include a key of "<io_code>" and value "<ratio>"
    Examples:
      | naics  | io_code | ratio |
      | 111111 | 111000  | 1.0   |
      | 399100 | 3991A0  | 0.75  |
      | 399100 | 3991B0  | 0.25  |
      | 399200 | 399200  | 1.0   |
      | 399900 | 399900  | 1.0   |

  Scenario Outline: Industry sector shares committee from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "adjusted_cost" of "100.00"
    When the "merchant_category_industries" committee is calculated
    And the "non_trade_industry_ratios" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    And the "industry_product_ratios" committee is calculated
    And the "industry_ratios" committee is calculated
    And the "industry_sector_ratios" committee is calculated
    And the "industry_sector_shares" committee is calculated
    Then the conclusion of the committee should include a key of "<io_code>" and value "<share>"
    Examples:
      | mcc  | io_code | share   |
      | 1111 | 111000  | 100.0   |
      | 2222 | 3991A0  | 14.0625 |
      | 2222 | 3991B0  | 4.6875  |
      | 2222 | 399200  | 6.25    |
      | 2222 | 399900  | 50.0    |

  Scenario Outline: Sector shares committee from industry and product line shares
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "adjusted_cost" of "100.00"
    When the "merchant_category_industries" committee is calculated
    And the "non_trade_industry_ratios" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    And the "industry_product_ratios" committee is calculated
    And the "industry_ratios" committee is calculated
    And the "industry_sector_ratios" committee is calculated
    And the "industry_sector_shares" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should be a vector with values "<111000>,<3991A0>,<3991B0>,<399200>,<399900>,<4A0000>"
    Examples:
      | mcc|111000|3991A0 |3991B0|399200|399900|4A0000|
      |1111|100.00|      0|     0|     0|     0|     0|
      |2222|     0|14.0625|4.6875|  6.25|  50.0|     0|

  Scenario: Sector direct requirements committee
    Given a purchase emitter
    When the "sector_direct_requirements" committee is calculated
    Then the conclusion of the committee should be a square matrix with "6" rows and columns

  Scenario: Economic flows from merchant category
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "1111"
    And a characteristic "adjusted_cost" of "100"
    When the "merchant_category_industries" committee is calculated
    And the "non_trade_industry_ratios" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    And the "industry_product_ratios" committee is calculated
    And the "industry_ratios" committee is calculated
    And the "industry_sector_ratios" committee is calculated
    And the "industry_sector_shares" committee is calculated
    And the "sector_shares" committee is calculated
    And the "sector_direct_requirements" committee is calculated
    And the "economic_flows" committee is calculated
    Then the conclusion of the committee should be a vector with "6" items

  Scenario: Impact vectors committee
    Given a purchase emitter
    When the "impact_vectors" committee is calculated
    Then the conclusion of the committee should be a square matrix with "6" rows and columns

  Scenario Outline: Impacts committee from economic flows
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "adjusted_cost" of "100"
    When the "merchant_category_industries" committee is calculated
    And the "non_trade_industry_ratios" committee is calculated
    And the "trade_industry_ratios" committee is calculated
    And the "product_line_ratios" committee is calculated
    And the "product_line_industry_product_ratios" committee is calculated
    And the "industry_product_ratios" committee is calculated
    And the "industry_ratios" committee is calculated
    And the "industry_sector_ratios" committee is calculated
    And the "industry_sector_shares" committee is calculated
    And the "sector_shares" committee is calculated
    And the "sector_direct_requirements" committee is calculated
    And the "economic_flows" committee is calculated
    And the "impact_vectors" committee is calculated
    And the "impacts" committee is calculated
    Then the conclusion of the committee should be a vector with values "<111000>,<3991A0>,<3991B0>,<399200>,<399900>,<4A0000>"
    Examples:
      |mcc |111000  |3991A0  |3991B0  |399200  |399900   |4A0000  |
      |1111|90.44460| 6.83919| 5.58981| 18.5568|19.91952 |11.38220|
      |2222|28.14742|26.31519|16.92866|58.00083|105.81262|31.07553|

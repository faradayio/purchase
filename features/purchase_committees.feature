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
    When the "adjusted_cost" committee is calculated
    Then the committee should have used quorum "from purchase amount and date"
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
    Then the conclusion of the committee should have a record identified with "naics_code" of "<naics>" and having "ratio" of "<ratio>"
    Examples:
      | mcc  | naics  | ratio |
      | 5111 | 45321  | 1.0   |
      | 5172 | 32411  | 0.8   |
      | 5172 | 324121 | 0.05  |
      | 5172 | 324122 | 0.05  |
      | 5172 | 324191 | 0.05  |
      | 5172 | 324199 | 0.05  |

  Scenario Outline: Industry shares committee from naics codes and ratios
    Given a purchase emitter
    And a characteristic "naics_codes" including "<naics>"
    And a characteristic "naics_ratios" including "<naics_ratio>"
    When the "industry_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<result_naics>" and having "ratio" including "<ratio>"
    Examples:
    | naics                             | naics_ratio             | result_naics | ratio |
    | 45321                             | 1.0                     | 45321        | 1.0   |
    | 32411,324121,324122,324191,324199 | 0.8,0.05,0.05,0.05,0.05 | 32411        | 0.8   |
    | 32411,324121,324122,324191,324199 | 0.8,0.05,0.05,0.05,0.05 | 324121       | 0.05  |
    | 32411,324121,324122,324191,324199 | 0.8,0.05,0.05,0.05,0.05 | 324122       | 0.05  |
    | 32411,324121,324122,324191,324199 | 0.8,0.05,0.05,0.05,0.05 | 324191       | 0.05  |
    | 32411,324121,324122,324191,324199 | 0.8,0.05,0.05,0.05,0.05 | 324199       | 0.05  |

  Scenario Outline: Industry shares committee from naics codes
    Given a purchase emitter 
    And a characteristic "naics_codes" including "<naics>"
    When the "industry_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<result_naics>" and having "ratio" including "<ratio>"
    Examples:
      | naics        | result_naics | ratio |
      | 45321        | 45321        | 1.0   |
      | 32411,324121 | 32411        | 0.5   |
      | 32411,324121 | 324121       | 0.5   |

  Scenario Outline: Product line shares committee from industry shares
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    Then the conclusion of the committee should include a key of <ps_code> and value <ratio>
    Examples:
      | mcc  | ps_code  | ratio  |
      | 5111 | 20370    |    0.6 |
      | 5111 | 20852    |    0.2 |
      | 5111 | 20853    |    0.2 |

  Scenario Outline: Product line shares committee from ps codes and ratios
    Given a purchase emitter 
    And a characteristic "ps_codes" including "<ps_code>"
    And a characteristic "ps_ratios" including "<ps_ratio>"
    When the "product_line_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "ps_code" of "<result_ps>" and having "ratio" including "<ratio>"
    Examples:
      | ps_code     | ps_ratio | result_ps | ratio |
      | 20370,20852 | 0.6,0.2  | 20370     | 0.6   |
      | 20370,20852 | 0.6,0.2  | 20852     | 0.2   |

  Scenario Outline: Product line shares committee from ps codes
    Given a purchase emitter 
    And a characteristic "ps_codes" including "<ps_code>"
    When the "product_line_shares" committee is calculated
    Then the conclusion of the committee should have a record identified with "ps_code" of "<result_ps>" and having "ratio" including "<ratio>"
    Examples:
      | ps_code     | result_ps | ratio |
      | 20370       | 20370     | 1     |
      | 20370,20852 | 20370     | 0.5   |
      | 20370,20852 | 20852     | 0.5   |

  Scenario Outline: Sector shares committee from sectors
    Given a purchase emitter 
    And a characteristic "io_codes" including "<io_codes>"
    When the "product_lines_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should include a key of "<result_io_code>" and subvalue "share" of "<share>" and subvalue "emission_factor" of "<emission_factor>"
    Examples:
      | io_codes      | result_io_code | emission_factor | share  |
      | 322230,324110 | 322230         |             1.4 |    1.0 |
      | 322230,324110 | 324110         |             2.0 |    0.8 |
      | 324191        | 324191         |             0.2 |    1.0 |
      | 334111        | 334111         |             1.3 |    0.4 |
      | 33411A        | 33411A         |             0.5 |    1.0 |
      | 334210        | 334210         |             1.6 |    1.0 |
      | 334300        | 334300         |             1.2 |    1.0 |
      | 339940        | 339940         |             1.1 |    1.0 |
      | 511200        | 511200         |             1.0 |    0.3 |
      | 722000        | 722000         |             0.8 |    0.6 |
      | 44100         | 44100          |             0.7 |    1.0 |
      | 44102         | 44102          |             0.7 |    0.3 |
      | 44103         | 44103          |             1.2 |    1.0 |
      | 44104         | 44104          |             1.4 |    1.0 |
      | 44105         | 44105          |             0.3 |    0.4 |

  Scenario Outline: Sector shares committee from industry shares and product line shares
    Given a purchase emitter 
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

  Scenario Outline: Sector shares committee from ps_codes
    Given a purchase emitter 
    And a characteristic "ps_codes" including "<ps_codes>"
    When the "product_lines_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should include a key of "<io_code>" and subvalue "share" of "<share>" and subvalue "emission_factor" of "<emission_factor>"
    Examples:
      | ps_codes    | io_code | emission_factor | share  |
      | 20321,20370 | 334300  |             1.2 |      1 |
      | 20321,20370 | 334111  |             1.3 |    0.4 |
      | 20321,20370 | 33411A  |             0.5 |    0.3 |
      | 20321,20370 | 511200  |               1 |    0.3 |
      | 20321,20370 | 511200  |               1 |    0.3 |
      | 20375       | 33411A  |             0.5 |      1 |
      | 20852       | 322230  |             1.4 |      1 |
      | 20853       | 339940  |             1.1 |      1 |
      | 20865       | 334210  |             1.6 |      1 |
      | 30540       | 44100   |             0.7 |      1 |
      | 30860       | 324191  |             0.2 |      1 |
      | 30861       | 44102   |             0.7 |    0.3 |
      | 30862       | 44103   |             1.2 |      1 |
      | 30863       | 44104   |             1.4 |      1 |
      | 30864       | 44105   |             0.3 |    0.4 |
      | 7600        | 722000  |             0.8 |    0.6 |
      | 30860       | 324110  |               2 |    0.8 |

  Scenario Outline: Emission factor from sector shares
    Given a purchase emitter 
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
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "emission_factor" committee is calculated
    Then the conclusion of the committee should be "100"
    Examples:
      | mcc |
      | 0   |

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
    Then the conclusion of the committee should include a key of <io_code> and value <emission>
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

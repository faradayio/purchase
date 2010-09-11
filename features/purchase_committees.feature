Feature: Purchase Committee Calculations
  The purchase model should generate correct committee calculations

  Scenario: Cost committee from purchase amount
    Given a purchase emitter
    And a characteristic "purchase_amount" of "107.11"
    When the "cost" committee is calculated
    Then the committee should have used quorum "from purchase amount"
    And the conclusion of the committee should be "100"

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

  Scenario: Cost committee from default
    Given a purchase emitter
    When the "cost" committee is calculated
    Then the conclusion of the committee should be "100"

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
      | 3  | 5812 |
      | 9  | 9999 |

  Scenario: Merchant category committee from default
    Given a purchase emitter
    When the "merchant_category" committee is calculated
    Then the conclusion of the committee should have "mcc" of "5111"

  Scenario Outline: Merchant categories industries committee
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_categories_industries" committee is calculated
    Then the conclusion of the committee should have a record identified with "naics_code" of "<naics>" and having "ratio" of "<ratio>"
    Examples:
      | mcc  | naics  | ratio |
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
      | 5812 | 72211  | 1.0   |
      | 9999 | 999991 | 0.5   |
      | 9999 | 999992 | 0.5   |

  Scenario Outline: Product line shares committee from industry
    Given a purchase emitter
    And a characteristic "naics_code" of "<naics>"
    When the "product_line_shares" committee is calculated
    Then the committee should have used quorum "from industry"
    And the conclusion of the committee should have a record identified with "ps_code" of "<ps_code>" and having "ratio" of "<share>"
    Examples:
      | naics  | ps_code | share |
      | 72211  |         |       |
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
      | 5812 |         |       |
      | 9999 | 99992   | 0.375 |
      | 9999 | 99993   | 0.125 |

  Scenario Outline: Industries sectors committee from industry
    Given a purchase emitter
    And a characteristic "naics_code" of "<naics>"
    When the "industries_sectors" committee is calculated
    Then the committee should have used quorum "from industry"
    And the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "ratio" of "<share>"
    Examples:
      | naics  | io_code | share |
      | 45321  | 4A0000  | 1.0   |
      | 443112 | 4A0000  | 1.0   |
      | 72211  | 26      | 1.0   |
      | 999991 | A       | 0.75  |
      | 999991 | B       | 0.25  |
      | 999992 | 4A0000  | 1.0   |

  Scenario Outline: Industries sectors committee from merchant category
    Given a purchase emitter 
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "cost" of "100"
    And a characteristic "date" of "2010-08-01"
    When the "adjusted_cost" committee is calculated
    And the "merchant_categories_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "industries_sectors" committee is calculated
    Then the committee should have used quorum "from industry shares"
    And the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "ratio" of "<share>"
    Examples:
      | mcc  | io_code  | share |
      | 5812 | 26       | 1.0   |
      | 9999 | A        | 0.375 |
      | 9999 | B        | 0.125 |

  Scenario Outline: Sector shares committee from industry and product line shares
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    When the "merchant_categories_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "industries_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should be a vector with values "<26>,<A>,<B>,<C>,<D>"
    Examples:
      |mcc | 26    | A     | B     | C     | D     |
      |5218| 1.0   | 0     | 0     | 0     | 0     |
      |9999| 0     | 0.5625| 0.3125| 0.0625| 0.0625|

  Scenario: Sector direct requirements
    Given a purchase emitter
    When the "sector_direct_requirements" committee is calculated
    Then the conclusion of the committee should be a square matrix with "32" rows and columns

  Scenario: Economic flows from merchant category
    Given a purchase emitter
    And a characteristic "merchant_category.mcc" of "<mcc>"
    And a characteristic "date" of "2010-08-01"
    And a characteristic "cost" of "100"
    When the "adjusted_cost" committee is calculated
    And the "merchant_categories_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "industries_sectors" committee is calculated
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
    And the "merchant_categories_industries" committee is calculated
    And the "industry_shares" committee is calculated
    And the "product_line_shares" committee is calculated
    And the "industries_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    And the "sector_direct_requirements" committee is calculated
    And the "economic_flows" committee is calculated
    And the "impact_vectors" committee is calculated
    And the "impacts" committee is calculated
    Then the conclusion of the committee should be a vector with values "<1>,<2>,<3>,<4>,<5>,<6>,<7>,<8>,<9>,<10>,<11>,<12>,<13>,<14>,<15>,<16>,<17>,<18>,<19>,<20>,<21>,<22>,<23>,<24>,<25>,<26>,<44100>,<44102>,<44103>,<44104>,<44105>,<A>,<B>,<C>,<D>"
    Examples:
      |mcc |        1|        2|       3|        4|        5|        6|        7|        8|        9|       10|       11|       12|       13|       14|      15|       16|      17|      18|       19|       20|       21|       22|      23|       24|       25|       26|    44101|    44102|    44103|      44104|      44105|A|B|C|D|
      |3504|155.86731|104.03605|87.76257|291.34762|319.25215|182.42382|196.62746|114.82379|148.22195|168.43544|116.29640|264.81364|253.90832|250.65973|50.61214|114.76388|97.53452|73.10758|283.31637|826.63897|530.40921|342.37491|61.53280|539.83071|596.51261|669.04614|652.33331|89.75891|499.27980|855.05574|86951.89652|19202.37864|0|0|0|
      |5111|176.26289|102.83058|86.00555|295.90467|312.28563|178.39687|192.04036|114.04748|145.15336|164.47922|112.34880|255.55224|246.59470|241.86031|48.38700|106.22807|89.88757|68.15075|231.64745|797.76030|533.56031|353.38847|63.87759|563.10495|623.16602|702.44095|685.55325|94.33324|524.85891|898.86196|91482.61320|20203.13262|0|0|0|
      |5172|148.93540| 99.40924|83.85847|278.38705|305.05470|174.31126|187.92985|109.81514|141.75647|160.71289|111.11839|253.05321|242.98472|240.59612|47.63645|110.69211|94.21976|71.47218|239.76378|924.35508|536.75732|340.56397|60.96690|527.97880|576.38642|641.45263|624.71934|85.95569|477.97964|818.57755|83245.23160|18383.80940|0|0|0|
      |5732|148.32370| 99.00095|82.75370|274.71953|301.13906|172.07383|184.04352|106.71206|137.75081|168.67549|106.28682|250.17853|228.22505|223.52792|43.98102| 99.74646|84.55431|64.34777|219.21809|756.19418|504.85029|335.78869|60.75243|528.40372|604.48133|645.22938|625.88482|86.10317|478.28616|819.10249|83313.56277|18398.93787|0|0|0|
      |5812|138.96185| 92.75224|78.23810|259.72898|284.59469|162.62021|175.29280|102.43812|132.23373|150.03896|103.65006|236.02807|226.43032|224.52403|44.68648|102.65835|87.30892|67.36268|231.41317|805.28671|545.90561|366.67089|66.48097|595.56705|661.33645|760.93072|687.95256|94.38379|513.98681|880.24264|89729.95858|19816.43838|0|0|0|

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
        | 9999 | 99999A   | 0.375 |
        | 9999 | 99999B   | 0.125 |

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
    |mcc |       1|       2|       3|       4|       5|       6|       7|       8|       9|      10|      11|      12|      13|      14|      15|      16|      17|      18|   19| 20|  21|  22|  23|  24|  25| 26|44100|44101|44102|44103|44104|44105|
    |3504|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|    1|  0|   0|   0|   0|   0|   0|  0|    0|    0|    0|    0|    0|    0|
    |5111|0.344645|0.010505|0.000495|0.109180|0.004194|0.003245|0.002556|0.099200|0.025721|0.029618|0.001599|0.000762|0.084000|0.078175|0.194704|0.004251|0.001755|0.005395|    0|  0|   0|   0|   0|   0|   0|  0|    0|    0|    0|    0|    0|    0|
    |5172|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|    0|0.8|0.05|0.05|0.05|0.05|   0|  0|    0|    0|    0|    0|    0|    0|
    |5732|       0|       0|       0|       0|       0|       0|       0|       0|       0|     0.5|       0|    0.25|       0|       0|       0|       0|       0|       0|    0|  0|   0|   0|   0|   0|0.20|  0|    0|    0|    0|    0|    0|    0|
    |5812|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|       0|    0|  0|   0|   0|   0|   0|   0|  1|    0|    0|    0|    0|    0|    0|

  Scenario Outline: Sector shares committee from industry
    Given a purchase emitter 
    And a characteristic "industry.naics_code" of "<naics>"
    When the "sector_shares" committee is calculated
    Then the conclusion of the committee should be a vector with value "<share>" and position for key "<io_code>"
    Examples:
      | naics  | io_code | share |
      | 32411  | 20      | 1     | 
      | 324121 | 21      | 1     | 
      | 324122 | 22      | 1     |
      | 324191 | 23      | 1     |
      | 324199 | 24      | 1     |
      | 72111  | 19      | 1     |
      | 72211  | 26      | 1     |

  Scenario: Sector direct requirements
    Given a purchase emitter 
    When the "sector_direct_requirements" committee is calculated
    Then the conclusion of the committee should be a square matrix with "32" rows and columns

  Scenario Outline: Economic flows from merchant category
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
      |mcc |               1|               2|               3|               4|               5|               6|               7|               8|               9|              10|              11|              12|              13|              14|              15|              16|              17|              18|              19|              20|              21|              22|              23|              24|              25|              26|           44100|           44101|           44102|           44103|           44104|           44105|
      |3504|1.29834199613981| 1.2856131530404| 1.6540377795074|1.63813357008906|1.99447756075661|1.97566173471174|2.33980793269566|2.72792624286968|2.70289939660483|3.13938074356974|3.56666815264924|3.25452104918186|3.14917730146087|3.16118467367788|3.38105650418306|3.16051769696209|2.86120907388476|2.65196992491046| 3.4196286082012| 2.7887203163656|2.75287684948284|2.56672009873301|2.07584909110803| 3.0352566911447|2.51546761720421|5.64267663396095|6.28768236167871| 6.0561506773273|4.81243680878419|4.80764354503042|419.054106871362| 431.86981668725|
      |5111|1.58391281011125|1.30031884138467|1.65868740116662|1.76854501269386|1.99853919231398|1.97731911974498|2.3389731337385 |2.74812299919028|2.70579523772982|3.12575923247806| 3.5243756817205|3.21388182273388|3.13319514746544|3.13248598589508|3.25208933733575|3.02557366864928|2.73286117861436|2.57629476258478|2.92018544100691|2.81610432481636|2.90167123634534|2.78034770575658|2.26233596861017|3.32563518415701| 2.7606364066979|6.22749675976865|6.94577383392607|6.69023925885154|5.31761759742786|5.31232116555791|463.575821432931|477.759471047589|
      |5172|3.98442045127868|3.94535750567791| 5.0759720855136|5.02716466161443|6.12085219086195|6.06310830226891|7.18257003613112|8.37928109797439|8.30240695946086|9.61979427737296|10.9453326571595|9.98869626938368|9.68042414042497|9.74481176537176|10.2143341286528|9.79715965210471|8.88391340849007|8.31639153044148|9.25965734599066|10.0898251739008|8.85133438664836|8.06915859119059|6.46389695939542|9.43881491935983| 7.7649975401232|17.3478965348803|19.3191419237557|18.6073305431978|14.7836569956237|14.7689322376599|1287.34492020256|1326.71539090972|
      |5732|1.42752644552662|1.41353108821753|1.80846514412631|1.79107605620201|2.18522996034294|2.16461458335857|2.55080649485026|2.96055737524601|2.93339629840889|3.54813742655735|3.82652171334741| 3.5981029992499|3.34516531638228|3.34313582697078|3.49699469298264|3.28429957876585|2.96903131505612|2.80559861278949|3.19222148325511|3.09012558445881|3.17733203124024|3.08586277924427|2.51830314155899|3.59954968910327|3.22831408779592|6.44044241651895|7.08516872432836|6.82099420797597|5.40153426197184|5.39615424776669|470.551323979995|484.944337899519|
      |5812|1.65656251831264|1.64032170930958|2.11024335926233|2.08995255773096|2.54448739982238|2.52048280171085|2.98523341120662|3.48289623391733|3.45094305745937|4.00214430276379| 4.5492956049494|4.15134258144415|4.01913830905831|4.05234416171167|4.27220533606305|4.04599617783536|3.66545648888314|3.49706498673177|3.99736251104211|3.88792423798741|4.05481894935805|3.93397127585321|3.20970160745994|4.79232955565591|3.99116548383356|9.18443384393432|9.48981417368969|9.11369923563473|7.09008094560364|7.08301911199248|618.880342933187|637.825096949598|
      |8225|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|

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

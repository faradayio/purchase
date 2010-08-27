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
      |3504|2.32261537770985|2.2998446387127|2.95892268248193|2.93047150284268|3.56793839133562|3.53427859519095|4.18570292074358|4.8800111679243|4.83524042326445|5.61606573089399|6.38044392244944|5.82204123288347|5.63359087917865|5.65507097259013|6.048401617501|5.65387781209677|5.11844199263821|4.74413224492032|6.11740359248872|4.98876621890089|4.92464552680293|4.59162808360109|3.71350463525587|5.42979730079552|4.49994207013275|10.0942336922378|11.2480900924485|10.8339010327859|8.60901039138496|8.60043567983975|749.649565065049|772.575700692754|
      |5111|2.62653473767725|2.27319616181767|2.899684592835|2.97630781790389|3.49008113546696|3.45626055871727|4.08805494120237|4.84701826637587|4.73513828228068|5.48415521043809|6.16386405060023|5.61842551350218|5.47131996035558|5.45654957571004|5.78248669197305|5.23335852927722|4.71714381012848|4.42247086762032|5.0017617319416|4.81448345384947|4.95390229048053|4.73933206632809|3.85501271538159|5.6638973170664|4.70100873431658|10.5980778456761|11.8208967997742|11.3860225376715|9.05006725493334|9.04105324372325|788.710815292597|812.839369203695|
      |5172|2.21932147470439|2.19756342103082|2.82729536845749|2.80010983606847|3.40926879223119|3.37710587909693|4.00055260197743|4.6671437775956|4.62432594477362|5.35857640054244|6.09635945508885|5.56348335276284|5.39122347902383|5.42802854062428|5.69279173862291|5.45328096594959|4.94448939584308|4.63800710187908|5.17701046042082|5.57848294585553|4.98358529533821|4.56734133744687|3.67935245501151|5.31058686241423|4.34811510451864|9.67791662874685|10.7719463617903|10.3748519391239|8.24173478033687|8.23352588115326|717.69281822067|739.64193187458|
      |5732|2.21020639231582|2.18853770219508|2.79004802166704|2.76322063684332|3.36550791568978|3.33375784101346|3.91782239205091|4.53526292304001|4.49365500631487|5.62406954047773|5.83128187343705|5.50028207631013|5.06374344630928|5.04295712420528|5.25595025094864|4.91403990618506|4.43726327477081|4.17568599493588|4.73338528854363|4.56363193629379|4.68734080961951|4.50329945947913|3.66640956954832|5.3148608165698|4.56005603358144|9.7348984151924|10.7920426939166|10.3926534930168|8.24702008839533|8.23880592496067|718.28193051245|740.250600639369|
      |5812|2.0707031478908|2.05040213663697|2.63780419907792|2.6124406971637|3.18060924977798|3.15060350213856|3.73154176400827|4.35362029239666|4.31367882182421|5.00268037845474|5.68661950618675|5.18917822680519|5.02392288632289|5.06543020213958|5.34025667007881|5.05749522229419|4.58182061110393|4.37133123341471|4.99670313880264|4.85990529748426|5.06852368669756|4.91746409481652|4.01212700932493|5.99041194456989|4.98895685479195|11.4805423049179|11.8622677171121|11.3921240445434|8.86260118200456|8.8537738899906|773.600428666484|797.281371186998|
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

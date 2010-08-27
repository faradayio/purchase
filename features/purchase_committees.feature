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
      | 3  | 5812 |
      | 9  | 9999 |

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
    And a characteristic "industry.naics_code" of "<naics>"
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
    And a characteristic "industry.naics_code" of "<naics>"
    When the "industries_sectors" committee is calculated
    Then the committee should have used quorum "from industry"
    And the conclusion of the committee should have a record identified with "io_code" of "<io_code>" and having "ratio" of "<share>"
    Examples:
      | naics  | io_code | share |
      | 72211  | 26      | 1.0   |
      | 999991 | A       | 0.75  |
      | 999991 | B       | 0.25  |
      | 999992 | 4A0000  | 1.0   |

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
      | 5812 | 26       | 1.0   |
      | 9999 | A        | 0.375 |
      | 9999 | B        | 0.125 |

  Scenario Outline: Sector shares committee from industry
    Given a purchase emitter
    And a characteristic "adjusted_cost" of "1"
    And a characteristic "industry.naics_code" of "<naics>"
    When the "product_line_shares" committee is calculated
    And the "industries_sectors" committee is calculated
    And the "sector_shares" committee is calculated
    Then the conclusion of the committee should be a vector with values "<26>,<A>,<B>,<C>,<D>"
    Examples:
      |naics | 26   | A    | B    | C    | D    |
      |72211 | 1.0  | 0    | 0    | 0    | 0    |
      |999991| 0    | 0.75 | 0.25 | 0    | 0    |
      |999992| 0    | 0.375| 0.375| 0.125| 0.125|

  Scenario Outline: Sector shares committee from merchant category
    Given a purchase emitter 
    And a characteristic "adjusted_cost" of "1"
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
      |mcc |               1|               2|                3|               4|               5|               6|               7|               8|               9|              10|              11|              12|              13|              14|               15|              16|              17|               18|              19|              20|              21|              22|               23|              24|              25|              26|           44100|           44101|           44102|           44103|           44104|           44105|
      |3504|1.88131845594498|1.25571517273713| 1.05929432032853|3.51656580341122|3.85337346264247|2.20185556480396|2.37329355606161| 1.3859231716905|1.78903895660784|2.03301579458363|1.40369766293888|3.19630063685302|3.06467343827319|3.02546297033572|0.610888563367601|1.38520006396371|1.17724165830679|0.882408597555179| 3.4196286082012|9.97753243780179|6.40203918484381|4.13246527524098|0.742700927051174|6.51575676095462| 7.1999073122124|8.07538695379026|7.87366306471395|1.08339010327859|6.02630727396947|10.3205228158077|1049.50939109107|231.772710207826|
      |5111|2.12749313751857|1.24116510435245| 1.03808708423493|3.57156938148467|3.76928762630431|2.15325032808086|2.31792715166174|1.37655318765075|1.75200116444385|1.98526418617859|1.35605009113205| 3.0845156069127|2.97639805843344|2.91925402300487|0.584031155889278|1.28217283967292|1.08494307632955| 0.82257958137738|2.79598480815535|9.62896690769895|6.44007297762469|4.26539885969528|0.771002543076318|6.79667678047968|7.52161397490653|8.47846227654088|8.27462775984191|1.13860225376715|6.33504707845334|10.8492638924679|1104.19514140964|243.851810761108|
      |5172|1.79765039451056|1.19986962788283| 1.01217174190778|3.36013180328216|3.68201029560969|2.10393696267739| 2.2683133253212|1.32546883283715|1.71100059956624|1.93980465699636|1.34119908011955| 3.0543523606668|2.93282557258896|2.90399526923399|0.574971965600914|1.33605383665765|1.13723256104391|0.862669320949508|2.89394884737524|11.1569658917111|6.47866088393967|4.11060720370218|0.735870491002303|6.37270423489708|6.95698416722982|7.74233330299748|7.54036245325319|1.03748519391239|5.76921434623581|9.88023105738391|1004.76994550894|221.892579562374|
      |5732|1.79026717777581|1.19494158539851|0.998837191756801|3.31586476421198|3.63474854894496|2.07693113495139|2.22140529629287|1.28801467014336| 1.6626523523365|2.03591317365294|1.28288201215615|3.01965485989426|2.75467643479225|2.69798206144982|0.530850975345812|1.20393977701534|1.02057055319729|0.776677595058074|2.64596237629589|9.12726387258758|6.09354305250536|4.05296951353121|0.733281913909665|6.37783297988376|7.29608965373031|7.78791873215392|7.55442988574164|1.03926534930168|5.77291406187673| 9.8865671099528|1005.59470271743|222.075180191811|
      |5812|1.67726954979155|1.11951956660379|0.944333903269894|3.13492883659645|3.43505798976021|1.96282598183232|2.11578418019269|1.23642816304065|1.59606116407496|1.81097029700062|1.25105629136108|2.84885884651605|2.73301405015965|2.71000515814468| 0.53936592367796|1.23908632946208| 1.0538187405539|0.813067609415136|2.79315705459068|9.71981059496852|6.58908079270682|4.42571768533486|0.802425401864986|7.18849433348387|7.98233096766713|9.18443384393432|8.30358740197848|1.13921240445434|6.20382082740319|10.6245286679887|1083.04060013308|239.184411356099|
      |8225|               0|               0|                0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|                0|               0|               0|                0|               0|               0|               0|               0|                0|               0|               0|               0|               0|               0|               0|               0|               0|               0|

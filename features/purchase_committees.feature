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

  Scenario Outline: Sector shares committee from industry
    Given a purchase emitter
    And a characteristic "cost" of "100"
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
    Then the conclusion of the committee should be a vector with values "<1>,<2>,<3>,<4>,<5>,<6>,<7>,<8>,<9>,<10>,<11>,<12>,<13>,<14>,<15>,<16>,<17>,<18>,<19>,<20>,<21>,<22>,<23>,<24>,<25>,<26>,<44100>,<44101>,<44102>,<44103>,<44104>,<44105>"
    Examples:
      |mcc |        1|        2|        3|        4|        5|        6|        7|        8|        9|       10|       11|       12|       13|       14|       15|       16|       17|       18|       19|       20|       21|       22|       23|       24|       25|       26|    44100|    44101|    44102|    44103|      44104|      44105|
      |3504|192.42878|190.54222|245.14686|242.78968|295.60384|292.81512|346.78566|404.30912|400.59986|465.29127|528.62004|482.35635|466.74323|468.52286|501.11032|468.42401|424.06313|393.05155|506.82714|413.31948|408.00708|380.41657|307.66401|449.85893|372.82038|836.30767|931.90473|897.58914|713.25686|712.54645|62108.49751|64007.92880|
      |5111|217.60851|188.33439|240.23898|246.58722|289.15336|286.35133|338.69552|401.57566|392.30640|454.36248|510.67639|465.48678|453.29908|452.07535|479.07926|433.58397|390.81556|366.40189|414.39616|398.88015|410.43100|392.65385|319.38796|469.25412|389.47876|878.05118|979.36178|943.33243|749.79844|749.05163|65344.72371|67343.77541|
      |5172|183.87087|182.06822|234.24153|231.98921|282.45806|279.79336|331.44594|386.67305|383.12559|443.95827|505.08363|460.93482|446.66308|449.71238|471.64803|451.80455|409.65115|384.25908|428.91553|462.17754|412.89024|378.40441|304.83450|439.98234|360.24151|801.81579|892.45620|859.55691|682.82806|682.14796|59460.87972|61279.36469|
      |5732|183.11569|181.32043|231.15559|228.93294|278.83247|276.20197|324.59174|375.74672|372.29950|465.95439|483.12194|455.69859|419.53135|417.80920|435.45569|407.12840|367.62744|345.95575|392.16116|378.09709|388.34638|373.09854|303.76218|440.33643|377.80083|806.53673|894.12118|861.03177|683.26595|682.58541|59509.68769|61329.79292|
      |5812|171.55784|169.87590|218.54218|216.44081|263.51360|261.02763|309.15838|360.69762|357.38846|414.47227|471.13666|429.92363|416.23221|419.67110|442.44048|419.01368|379.60402|362.16497|413.97706|402.64335|419.92739|407.41210|332.40488|496.30587|413.33528|951.16340|982.78937|943.83794|734.26687|733.53553|64092.82756|66054.79463|

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
    Then the conclusion of the committee should be a vector with values "<1>,<2>,<3>,<4>,<5>,<6>,<7>,<8>,<9>,<10>,<11>,<12>,<13>,<14>,<15>,<16>,<17>,<18>,<19>,<20>,<21>,<22>,<23>,<24>,<25>,<26>,<44100>,<44101>,<44102>,<44103>,<44104>,<44105>"
    Examples:
      |mcc |               1|               2|                3|               4|               5|               6|               7|               8|               9|              10|              11|              12|              13|              14|               15|              16|              17|               18|              19|              20|              21|              22|               23|              24|              25|              26|           44100|           44101|           44102|           44103|           44104|           44105|
      |3504|1.88131845594498|1.25571517273713| 1.05929432032853|3.51656580341122|3.85337346264247|2.20185556480396|2.37329355606161| 1.3859231716905|1.78903895660784|2.03301579458363|1.40369766293888|3.19630063685302|3.06467343827319|3.02546297033572|0.610888563367601|1.38520006396371|1.17724165830679|0.882408597555179| 3.4196286082012|9.97753243780179|6.40203918484381|4.13246527524098|0.742700927051174|6.51575676095462| 7.1999073122124|8.07538695379026|7.87366306471395|1.08339010327859|6.02630727396947|10.3205228158077|1049.50939109107|231.772710207826|
      |5111|2.12749313751857|1.24116510435245| 1.03808708423493|3.57156938148467|3.76928762630431|2.15325032808086|2.31792715166174|1.37655318765075|1.75200116444385|1.98526418617859|1.35605009113205| 3.0845156069127|2.97639805843344|2.91925402300487|0.584031155889278|1.28217283967292|1.08494307632955| 0.82257958137738|2.79598480815535|9.62896690769895|6.44007297762469|4.26539885969528|0.771002543076318|6.79667678047968|7.52161397490653|8.47846227654088|8.27462775984191|1.13860225376715|6.33504707845334|10.8492638924679|1104.19514140964|243.851810761108|
      |5172|1.79765039451056|1.19986962788283| 1.01217174190778|3.36013180328216|3.68201029560969|2.10393696267739| 2.2683133253212|1.32546883283715|1.71100059956624|1.93980465699636|1.34119908011955| 3.0543523606668|2.93282557258896|2.90399526923399|0.574971965600914|1.33605383665765|1.13723256104391|0.862669320949508|2.89394884737524|11.1569658917111|6.47866088393967|4.11060720370218|0.735870491002303|6.37270423489708|6.95698416722982|7.74233330299748|7.54036245325319|1.03748519391239|5.76921434623581|9.88023105738391|1004.76994550894|221.892579562374|
      |5732|1.79026717777581|1.19494158539851|0.998837191756801|3.31586476421198|3.63474854894496|2.07693113495139|2.22140529629287|1.28801467014336| 1.6626523523365|2.03591317365294|1.28288201215615|3.01965485989426|2.75467643479225|2.69798206144982|0.530850975345812|1.20393977701534|1.02057055319729|0.776677595058074|2.64596237629589|9.12726387258758|6.09354305250536|4.05296951353121|0.733281913909665|6.37783297988376|7.29608965373031|7.78791873215392|7.55442988574164|1.03926534930168|5.77291406187673| 9.8865671099528|1005.59470271743|222.075180191811|
      |5812|1.67726954979155|1.11951956660379|0.944333903269894|3.13492883659645|3.43505798976021|1.96282598183232|2.11578418019269|1.23642816304065|1.59606116407496|1.81097029700062|1.25105629136108|2.84885884651605|2.73301405015965|2.71000515814468| 0.53936592367796|1.23908632946208| 1.0538187405539|0.813067609415136|2.79315705459068|9.71981059496852|6.58908079270682|4.42571768533486|0.802425401864986|7.18849433348387|7.98233096766713|9.18443384393432|8.30358740197848|1.13921240445434|6.20382082740319|10.6245286679887|1083.04060013308|239.184411356099|
      |8225|               0|               0|                0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|               0|                0|               0|               0|                0|               0|               0|               0|               0|                0|               0|               0|               0|               0|               0|               0|               0|               0|               0|

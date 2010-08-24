Feature: Purchase Economic Flows Committee Calculations
  The purchase model should generate correct economic flows committee calculations

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
    Then the conclusion of the committee should be a single-row matrix with values "<1>,<2>,<3>,<4>,<5>,<6>,<7>,<8>,<9>,<10>,<11>,<12>,<13>,<14>,<15>,<16>,<17>,<18>,<19>,<20>,<21>,<22>,<23>,<24>,<25>,<26>,<44100>,<44101>,<44102>,<44103>,<44104>,<44105>"
    Examples:
      |mcc |1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|44100|44101|44102|44103|44104|44105|
      |3504|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|0.559|00|00|00|00|00|00|00|00000|00000|00000|00000|00000|00000|
      |5111|0.29365|0.06580|0.013337|0.19108|0.019023|0.06208|0.01594|0.08823|0.02401|0.07078|0.01484|0.06048|0.06018|0.10188|0.03415|0.06110|0.02100|0.06106|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|0.01449|0.06006|
      |5172|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|00|1.6|0.065|0.045|0.01|0.06|00|00|00000|00000|00000|00000|00000|00000|
      |5732|0|0|0|0|0|0|0|0|0|0.181|00|0.13725|00|00|00|00|00|00|00|00|00|00|00|00|0.32|00|00000|00000|00000|00000|00000|00000|
      |5812|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|0.8|00000|00000|00000|00000|00000|00000|
      |8225|0|0|0|0|0|0|0|0|0|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00|00000|00000|00000|00000|00000|00000|

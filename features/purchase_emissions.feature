Feature: Purchase Emissions Calculations
  The purchase model should generate correct emission calculations

  Background:
    Given a purchase

  Scenario: Calculations starting from nothing
    Given it is the year "2010"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.001" kgs of "789.625"

  Scenario: Calculations starting from purchase amount
    Given it has "purchase_amount" of "107.11"
    And it is the year "2010"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.001" kgs of "126.538"

  Scenario: Calculations starting from date
    Given it has "date" of "2010-07-28"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.001" kgs of "789.625"

  Scenario Outline: Calculations starting from a merchant
    Given it has "merchant.id" of "<id>"
    And it is the year "2010"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | emission |
      | 1   |  789.625 |
      | 2   | 1710.633 |

  Scenario Outline: Calculations starting from a merchant with purchase amount
    Given it has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    And it is the year "2010"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | amount | emission |
      | 1   | 107.11 |  126.538 |
      | 2   | 107.11 |  274.131 |
  
  Scenario Outline: Calculations starting from a merchant with purchase amount and date
    Given it has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    And it has "date" of "<date>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | amount | date       | emission |
      | 1   | 107.11 | 2010-07-28 |  126.538 |
      | 2   | 107.11 | 2010-07-28 |  274.131 |

  Scenario Outline: Calculations starting from a merchant with purchase amount, date, and tax
    Given it has "merchant.id" of "<id>"
    And it has "purchase_amount" of "<amount>"
    And it has "tax" of "<tax>"
    And it has "date" of "<date>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.001" kgs of "<emission>"
    Examples:
      | id  | amount | tax  | date       | emission |
      | 1   | 108.00 | 8.00 | 2010-07-28 |  126.538 |
      | 2   | 108.00 | 8.00 | 2010-07-28 |  274.131 |
  
  Scenario Outline: Calculations starting from a merchant category
    Given it has "merchant_category.mcc" of "<mcc>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.001" kgs of "<emission>"
    Examples:
      | mcc  | cost   | date       | emission |
      | 1111 | 100.00 | 2010-07-28 |  126.538 |
      | 2222 | 100.00 | 2010-07-28 |  274.131 |

  Scenario Outline: Calculations starting from industry
    Given it has "industry.naics_code" of "<naics>"
    And it has "cost" of "<cost>"
    And it has "date" of "<date>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.001" kgs of "<emission>"
    And the "trade_industry_ratios" committee should have used quorum "from industry"
    And the "non_trade_industry_ratios" committee should have used quorum "from industry"
    Examples:
      | naics  | cost   | date       | emission |
      | 111111 | 100.00 | 2010-07-28 |  126.538 |
      | 399900 | 100.00 | 2010-07-28 |  334.190 |
      | 459000 | 100.00 | 2010-07-28 |  214.072 |

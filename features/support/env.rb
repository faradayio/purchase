require 'bundler'
Bundler.setup

require 'cucumber'
require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support

require 'data_miner'
DataMiner.logger = Logger.new nil

require 'sniff'
Sniff.init File.join(File.dirname(__FILE__), '..', '..'), :earth => :industry, :cucumber => true, :logger => 'log/test_log.txt'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'test_impact_vectors_adapter'
require 'test_sector_direct_requirements_adapter'

BrighterPlanet::Purchase.sector_direct_requirements_adapter = BrighterPlanet::Purchase::TestSectorDirectRequirementsAdapter
BrighterPlanet::Purchase.impact_vectors_adapter = BrighterPlanet::Purchase::TestImpactVectorsAdapter

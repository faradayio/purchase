require 'bundler'
Bundler.setup

require 'cucumber'

require 'sniff'
Sniff.init File.join(File.dirname(__FILE__), '..', '..'),
  # :adapter => 'mysql2',
  # :database => 'test_flight',
  # :username => 'root',
  # :password => 'password',
  :earth => :industry,
  :cucumber => true,
  :logger => 'log/test_log.txt'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'test_impact_vectors_adapter'
require 'test_sector_direct_requirements_adapter'

BrighterPlanet::Purchase.sector_direct_requirements_adapter = BrighterPlanet::Purchase::TestSectorDirectRequirementsAdapter
BrighterPlanet::Purchase.impact_vectors_adapter = BrighterPlanet::Purchase::TestImpactVectorsAdapter

require 'bundler/setup'

require 'sniff'
Sniff.init File.expand_path('../../..', __FILE__),
  :cucumber => true,
  :logger => false # change this to $stderr to see database activity

require_relative 'test_impact_vectors_adapter'
BrighterPlanet::Purchase.impact_vectors_adapter = BrighterPlanet::Purchase::TestImpactVectorsAdapter
require_relative 'test_sector_direct_requirements_adapter'
BrighterPlanet::Purchase.sector_direct_requirements_adapter = BrighterPlanet::Purchase::TestSectorDirectRequirementsAdapter

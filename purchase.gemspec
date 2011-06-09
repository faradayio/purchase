# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "purchase/version"

Gem::Specification.new do |s|
  s.name = %q{purchase}
  s.version = BrighterPlanet::Purchase::VERSION

  s.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", "Derek Kastner"]
  s.date = %q{2010-12-07}
  s.summary = %q{A carbon model}
  s.description = %q{A software model in Ruby for the greenhouse gas emissions of a purchase}
  s.email = %q{seamus@brighterplanet.com}
  s.homepage = %q{http://github.com/brighterplanet/purchase}

  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'emitter' unless ENV['LOCAL_EMITTER']
  s.add_development_dependency 'sniff' unless ENV['LOCAL_SNIFF']
  
  # weird
  s.add_development_dependency 'actionpack'
end


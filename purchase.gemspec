# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{purchase}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", "Derek Kastner"]
  s.date = %q{2010-07-27}
  s.description = %q{A software model in Ruby for the greenhouse gas emissions of a purchase}
  s.email = %q{seamus@brighterplanet.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    "LICENSE",
     "README.markdown",
     "lib/purchase.rb",
     "lib/purchase/carbon_model.rb",
     "lib/purchase/characterization.rb",
     "lib/purchase/data.rb",
     "lib/purchase/summarization.rb",
     "lib/test_support/db/schema.rb",
     "lib/test_support/purchase_record.rb"
  ]
  s.homepage = %q{http://github.com/brighterplanet/purchase}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A carbon model}
  s.test_files = [
    "features/support/env.rb",
     "features/purchase_committees.feature",
     "features/purchase_emissions.feature",
     "lib/test_support/db/schema.rb",
     "lib/test_support/purchase_record.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0.beta.2"])
      s.add_development_dependency(%q<cucumber>, ["= 0.8.3"])
      s.add_development_dependency(%q<jeweler>, ["= 1.4.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["= 2.0.0.beta.17"])
      s.add_development_dependency(%q<sniff>, ["= 0.0.10"])
      s.add_runtime_dependency(%q<characterizable>, ["= 0.0.12"])
      s.add_runtime_dependency(%q<data_miner>, ["= 0.5.2"])
      s.add_runtime_dependency(%q<earth>, ["= 0.0.7"])
      s.add_runtime_dependency(%q<falls_back_on>, ["= 0.0.2"])
      s.add_runtime_dependency(%q<fast_timestamp>, ["= 0.0.4"])
      s.add_runtime_dependency(%q<leap>, ["= 0.4.1"])
      s.add_runtime_dependency(%q<summary_judgement>, ["= 1.3.8"])
      s.add_runtime_dependency(%q<timeframe>, ["= 0.0.8"])
    else
      s.add_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
      s.add_dependency(%q<bundler>, [">= 1.0.0.beta.2"])
      s.add_dependency(%q<cucumber>, ["= 0.8.3"])
      s.add_dependency(%q<jeweler>, ["= 1.4.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<rspec>, ["= 2.0.0.beta.17"])
      s.add_dependency(%q<sniff>, ["= 0.0.10"])
      s.add_dependency(%q<characterizable>, ["= 0.0.12"])
      s.add_dependency(%q<data_miner>, ["= 0.5.2"])
      s.add_dependency(%q<earth>, ["= 0.0.7"])
      s.add_dependency(%q<falls_back_on>, ["= 0.0.2"])
      s.add_dependency(%q<fast_timestamp>, ["= 0.0.4"])
      s.add_dependency(%q<leap>, ["= 0.4.1"])
      s.add_dependency(%q<summary_judgement>, ["= 1.3.8"])
      s.add_dependency(%q<timeframe>, ["= 0.0.8"])
    end
  else
    s.add_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
    s.add_dependency(%q<bundler>, [">= 1.0.0.beta.2"])
    s.add_dependency(%q<cucumber>, ["= 0.8.3"])
    s.add_dependency(%q<jeweler>, ["= 1.4.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<rspec>, ["= 2.0.0.beta.17"])
    s.add_dependency(%q<sniff>, ["= 0.0.10"])
    s.add_dependency(%q<characterizable>, ["= 0.0.12"])
    s.add_dependency(%q<data_miner>, ["= 0.5.2"])
    s.add_dependency(%q<earth>, ["= 0.0.7"])
    s.add_dependency(%q<falls_back_on>, ["= 0.0.2"])
    s.add_dependency(%q<fast_timestamp>, ["= 0.0.4"])
    s.add_dependency(%q<leap>, ["= 0.4.1"])
    s.add_dependency(%q<summary_judgement>, ["= 1.3.8"])
    s.add_dependency(%q<timeframe>, ["= 0.0.8"])
  end
end

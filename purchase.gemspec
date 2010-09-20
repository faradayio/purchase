# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{purchase}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", "Derek Kastner"]
  s.date = %q{2010-09-20}
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
     "lib/test_support/purchase_record.rb",
     "lib/test_support/test_impact_vectors_adapter.rb",
     "lib/test_support/test_sector_direct_requirements_adapter.rb"
  ]
  s.homepage = %q{http://github.com/brighterplanet/purchase}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A carbon model}
  s.test_files = [
    "features/step_definitions/matrix.rb",
     "features/support/env.rb",
     "features/support/matrix_ext.rb",
     "features/purchase_committees.feature",
     "features/purchase_emissions.feature",
     "lib/test_support/db/schema.rb",
     "lib/test_support/purchase_record.rb",
     "lib/test_support/test_impact_vectors_adapter.rb",
     "lib/test_support/test_sector_direct_requirements_adapter.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<activerecord>, ["~> 3.0.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<cucumber>, ["~> 0.8.3"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.4.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0.beta.17"])
      s.add_development_dependency(%q<sniff>, ["~> 0.1.16"])
      s.add_runtime_dependency(%q<emitter>, ["~> 0.0.13"])
    else
      s.add_dependency(%q<activerecord>, ["~> 3.0.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<cucumber>, ["~> 0.8.3"])
      s.add_dependency(%q<jeweler>, ["~> 1.4.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.17"])
      s.add_dependency(%q<sniff>, ["~> 0.1.16"])
      s.add_dependency(%q<emitter>, ["~> 0.0.13"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 3.0.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<cucumber>, ["~> 0.8.3"])
    s.add_dependency(%q<jeweler>, ["~> 1.4.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.17"])
    s.add_dependency(%q<sniff>, ["~> 0.1.16"])
    s.add_dependency(%q<emitter>, ["~> 0.0.13"])
  end
end


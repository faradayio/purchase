require 'rubygems'

def require_or_fail(gems, message, failure_results_in_death = false)
  gems = [gems] unless gems.is_a?(Array)

  begin
    gems.each { |gem| require gem }
    yield
  rescue LoadError
    puts message
    exit if failure_results_in_death
  end
end

unless ENV['NOBUNDLE']
  message = <<-MESSAGE
In order to run tests, you must:
  * `gem install bundler`
  * `bundle install`
  MESSAGE
  require_or_fail('bundler',message,true) do
    Bundler.setup
  end
end

require_or_fail('jeweler', 'Jeweler (or a dependency) not available. Install it with: gem install jeweler') do
  Jeweler::Tasks.new do |gem|
    gem.name = %q{purchase}
    gem.summary = %q{A carbon model}
    gem.description = %q{A software model in Ruby for the greenhouse gas emissions of a purchase}
    gem.email = %q{seamus@brighterplanet.com}
    gem.homepage = %q{http://github.com/brighterplanet/purchase}
    gem.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", 'Derek Kastner']
    gem.files = ['LICENSE', 'README.markdown'] + 
      Dir.glob(File.join('lib', '**','*.rb'))
    gem.test_files = Dir.glob(File.join('features', '**', '*.rb')) +
      Dir.glob(File.join('features', '**', '*.feature')) +
      Dir.glob(File.join('lib', 'test_support', '**/*.rb'))
    gem.add_development_dependency 'activerecord', '~>3.0.0'
    gem.add_development_dependency 'bundler', '~>1.0.0'
    gem.add_development_dependency 'cucumber'
    gem.add_development_dependency 'jeweler', '~>1.4.0'
    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'rdoc'
    gem.add_development_dependency 'rspec', '~>2.0.0.beta.17'
    gem.add_development_dependency 'sniff', '~>0.2.3' unless ENV['LOCAL_SNIFF']
    gem.add_runtime_dependency 'actionpack', '~> 3.0.1'
    gem.add_runtime_dependency 'earth', '~>0.2.4' unless ENV['LOCAL_EARTH']
    gem.add_runtime_dependency 'emitter', '~>0.1.9' unless ENV['LOCAL_EMITTER']
    gem.add_runtime_dependency 'fastercsv', '~>1.5.3' unless ENV['LOCAL_EMITTER']
    gem.add_runtime_dependency 'slither', '~>0.99.3' unless ENV['LOCAL_EMITTER']
  end
  Jeweler::GemcutterTasks.new
end

require_or_fail('sniff', 'Sniff gem not found, sniff tasks unavailable') do
  require 'sniff/rake_task'
  Sniff::RakeTask.new(:console) do |t|
    t.earth_domains = :industry
  end
end

require_or_fail('cucumber', 'Cucumber gem not found, cucumber tasks unavailable') do
  require 'cucumber/rake/task'

  desc 'Run all cucumber tests'
  Cucumber::Rake::Task.new(:features) do |t|
    if ENV['CUCUMBER_FORMAT']
      t.cucumber_opts = "features --format #{ENV['CUCUMBER_FORMAT']}"
    else
      t.cucumber_opts = 'features --format pretty'
    end
  end

  desc "Run all tests with RCov"
  Cucumber::Rake::Task.new(:features_with_coverage) do |t|
    t.cucumber_opts = "features --format pretty"
    t.rcov = true
    t.rcov_opts = ['--exclude', 'features']
  end

  task :test => :features
  task :default => :test
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lodging #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'bundler/setup'

require 'purchase'

require 'sniff/rake_tasks'
Sniff::RakeTasks.define_tasks

namespace :purchase do
  namespace :db do
    task :env do
      require_relative 'features/support/merchant'
    end
    task :migrate => :env do
      Merchant.auto_upgrade!
    end
    task :seed => :env do
      Merchant.delete_all
      CSV.foreach(File.expand_path('../features/support/db/fixtures/merchants.csv', __FILE__), :headers => true) do |row|
        ActiveRecord::Base.connection.insert_fixture(row, 'merchants')
      end
    end
  end
end

task 'db:migrate' => 'purchase:db:migrate'
task 'db:seed' => 'purchase:db:seed'

namespace :m do
  
  desc 'Load the seed data from db/seeds.rb'
  task :seed => 'db:abort_if_pending_migrations' do
    seed_file = File.join(File.dirname(__FILE__), '..', '..', 'db', 'seeds.rb')
    load(seed_file) if File.exist?(seed_file)
  end
  
  task :schema => :environment do
    ENV['SCHEMA'] = File.join(File.dirname(__FILE__), '..', '..', 'db', 'schema.rb')
    Rake::Task['db:schema:load'].invoke
  end
  
  task :setup => ['db:drop', 'db:create', :schema, :seed] do
  end
  
end
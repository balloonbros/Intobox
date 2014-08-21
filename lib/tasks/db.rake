namespace :db do
  desc 'Drop and create and migrate the database'
  task init: :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
end

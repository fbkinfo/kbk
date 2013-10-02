namespace :db do
  desc 'Remove and install new database from scratch'
  task :prepare => [:'db:drop', :'db:create', :'db:migrate', :'db:seed']
end

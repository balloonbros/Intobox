set :application, 'Intobox'
set :stages, %w(production staging)
set :repo_url, 'git@bitbucket.org:keita_kawamoto/new-intobox.git'
set :user, 'intobox'
set :linked_dirs, %w(log)

role :app, %w{intobox@intobox.in}
role :web, %w{intobox@intobox.in}
role :db,  %w{intobox@intobox.in}

set :keep_releases, 5

before 'deploy:published', 'deploy:unicorn_start'
before 'deploy:finished', 'whenever:update_crontab' if fetch(:rails_env) == 'production'

namespace :deploy do
  desc 'restart a unicorn or start a unicorn if it is not launch'
  task :unicorn_start do
    on roles(:all) do
      execute "mkdir -p #{shared_path}/pids"
      pid_file = "#{shared_path}/pids/unicorn.pid"
      if test "[ -e #{pid_file} ]"
        execute "kill -USR2 `cat #{pid_file}`"
      else
        execute "cd #{current_path} && UNICORN_PID=#{pid_file} bundle exec unicorn -p #{fetch(:unicorn_port)} -E #{fetch(:rails_env)} -c #{current_path}/config/unicorn.rb -D"
      end
    end
  end

  desc 'stop a unicorn'
  task :stop do
    on roles(:all) do
      execute "kill -QUIT `cat #{shared_path}/pids/unicorn.pid`"
    end
  end

  desc 'restart a unicorn'
  task :restart do
    on roles(:all) do
      execute "kill -USR2 `cat #{shared_path}/pids/unicorn.pid`"
    end
  end
end

namespace :whenever do
  desc "update crontab using whenever's schedule"
  task :update_crontab do
    on roles(:all) do
      execute "cd #{current_path} && RAILS_ENV=#{fetch(:rails_env)} bundle exec whenever -w"
    end
  end
end

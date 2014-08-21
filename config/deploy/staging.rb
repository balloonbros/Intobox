set :stage, :staging
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :deploy_to, '/home/intobox/staging'
set :rails_env, 'staging'
set :unicorn_port, '8060'

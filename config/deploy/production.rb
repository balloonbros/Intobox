set :stage, :production
set :branch, :master
set :deploy_to, '/home/intobox/production'
set :rails_env, 'production'
set :unicorn_port, '8070'

after 'deploy:finished', 'deploy:notify'

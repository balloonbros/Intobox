require 'capistrano/setup'
require 'capistrano/deploy'

set :rbenv_type, :system
set :rbenv_ruby, '2.0.0-p247'

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }

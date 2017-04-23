# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require 'capistrano/rvm'
require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
# require 'capistrano/passenger'

require 'capistrano/puma'
install_plugin Capistrano::Puma  # Default puma tasks

require 'capistrano/puma/workers'
require 'capistrano/puma/nginx'
require 'capistrano/secrets_yml'

require 'capistrano/sidekiq'

require "whenever/capistrano"
# require 'capistrano/sidekiq/monit' #to require monit tasks # Only for capistrano3

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

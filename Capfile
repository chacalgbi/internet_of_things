require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/puma'
# require 'capistrano/scm/git'

# install_plugin Capistrano::SCM::Git
# install_plugin Capistrano::Puma
# install_plugin Capistrano::Puma::Daemon

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

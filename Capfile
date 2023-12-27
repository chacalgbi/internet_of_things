require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/puma'
require 'capistrano/scm/git'
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma
# install_plugin Capistrano::Puma::Daemon

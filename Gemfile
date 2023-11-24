source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.2"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "mysql2", "~> 0.5"
gem "httparty"
gem 'dotenv-rails'
gem 'mqtt', :github => 'njh/ruby-mqtt'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rubocop'
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

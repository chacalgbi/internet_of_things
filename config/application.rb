# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module InternetOfThings
  class Application < Rails::Application
    config.load_defaults 7.1
    config.active_job.queue_adapter = :async
    config.autoload_lib(ignore: %w[assets tasks])
  end
end

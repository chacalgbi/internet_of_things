# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module InternetOfThings
  class Application < Rails::Application
    config.load_defaults 7.1
    config.active_job.queue_adapter = :async
    config.autoload_lib(ignore: %w[assets tasks])
    config.i18n.available_locales = %i[en pt-BR]
    # config.i18n.default_locale = :en
    config.i18n.default_locale = :"pt-BR"
    config.filter_parameters += %i[userAdmin passAdmin chat_id token]
  end
end

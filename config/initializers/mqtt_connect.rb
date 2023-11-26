# frozen_string_literal: true

Rails.application.config.after_initialize do
  MqttConnectJob.perform_later if Rails.env.development? || Rails.env.production?
end

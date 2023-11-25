# frozen_string_literal: true

require 'mqtt'

class MqttConnectJob < ApplicationJob
  queue_as :default

  def perform
    conect = { host: ENV['MQTT_HOST'], port: ENV['MQTT_PORT'], client_id: ENV['MQTT_CLIENT_ID'], username: ENV['MQTT_USER'], password: ENV['MQTT_PASSWORD'] }
    subscribles = ['/thome_lucas/portao/ativo', '/thome_lucas/caixa/percent']
    MQTT::Client.connect(conect) do |c|
      c.get(subscribles) do |topic, message|
        Log.info("#{topic}: #{message}")
      end
    end
  end
end

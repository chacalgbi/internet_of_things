# frozen_string_literal: true

require 'mqtt'

class MqttConnectJob < ApplicationJob
  queue_as :default
  @@client_mqtt = MQTT::Client.new

  def perform
    Log.alert('MQTT: Conectando ao broker...')
    subscribles = path_subscribles

    conect unless @@client_mqtt.connected?

    if @@client_mqtt.connected?
      Log.info('MQTT: Conectado com sucesso!')
      @@client_mqtt.get(subscribles) do |topic, message|
        handle_message(topic, message)
      end
    end
  rescue StandardError => e
    Log.error("#{e.class}: #{e.message}")
  end

  def self.mqtt_client
    @@client_mqtt
  end

  private

  def conect
    @@client_mqtt.host = ENV['MQTT_HOST']
    @@client_mqtt.port = ENV['MQTT_PORT']
    @@client_mqtt.username = ENV['MQTT_USER']
    @@client_mqtt.password = ENV['MQTT_PASSWORD']
    @@client_mqtt.client_id = ENV['MQTT_CLIENT_ID']
    @@client_mqtt.connect
  end

  def path_subscribles
    Channel.where('path LIKE ?', '%/ativo%')
           .or(Channel.where('path LIKE ?', '%/terminal_OUT%'))
           .pluck(:path)
  end

  def record_logs(topic, message)
    channel = Channel.find_by(path: topic)
    log = "#{channel.obs}\n#{message}"
    last_log = log.length > 800 ? log[-800, 800] : log
    channel.update(obs: last_log)
  end

  def handle_message(topic, message)
    if topic.include?('ativo') && message == '1'
      RedisConnection.client.set("timeMqtt#{topic}", Time.now.to_s)
    elsif topic.include?('terminal_OUT')
      record_logs(topic, message)
    end
  end
end

# frozen_string_literal: true

require 'mqtt'

class MqttConnectJob < ApplicationJob
  queue_as :default
  @@client = MQTT::Client.new

  def perform
    Log.alert('MQTT: Conectando ao broker...')
    subscribles = path_subscribles

    conect unless @@client.connected?

    if @@client.connected?
      Log.info('MQTT: Conectado com sucesso!')
      @@client.get(subscribles) do |topic, message|
        handle_message(topic, message)
      end
    end
  end

  def self.mqtt_client
    @@client
  end

  private

  def conect
    @@client.host = ENV['MQTT_HOST']
    @@client.port = ENV['MQTT_PORT']
    @@client.username = ENV['MQTT_USER']
    @@client.password = ENV['MQTT_PASSWORD']
    @@client.client_id = ENV['MQTT_CLIENT_ID']
    @@client.connect
  end

  def path_subscribles
    Channel.where('path LIKE ?', '%/ativo%')
           .or(Channel.where('path LIKE ?', '%/terminal_OUT%'))
           .pluck(:path)
  end

  def record_logs(topic, message)
    channel = Channel.find_by(path: topic)
    log = "#{channel.obs}\n#{message}"
    last_log = log.length > 450 ? log[-450, 450] : log
    channel.update(obs: last_log)
  end

  def handle_message(topic, message)
    if topic.include?('ativo')
      RedisConnection.client.set("timeMqtt#{topic}", Time.now.to_s)
    elsif topic.include?('terminal_OUT')
      record_logs(topic, message)
    end
  end
end

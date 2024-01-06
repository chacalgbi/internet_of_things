# frozen_string_literal: true

require 'mqtt'

class MqttSubscrible
  def initialize
    @client_mqtt = MQTT::Client.new
    @count = 0
    @@count_verify = Time.now
    connect
  end

  def connect
    if @client_mqtt.connected?
      Log.info('MQTT já Conectado!')
      search_subscribles
    else
      Log.alert('MQTT: Conectando ao broker...')
      conect
      search_subscribles if @client_mqtt.connected?
    end
  end

  private

  def search_subscribles
    subscribles = path_subscribles
    Log.info("MQTT Conectado com sucesso! \nPaths inscritos:\n #{subscribles}}")

    @client_mqtt.get(subscribles) do |topic, message|
      handle_message(topic, message)
    end
  end

  def conect
    @client_mqtt.host = ENV['MQTT_HOST']
    @client_mqtt.port = ENV['MQTT_PORT']
    @client_mqtt.username = ENV['MQTT_USER']
    @client_mqtt.password = ENV['MQTT_PASSWORD']
    @client_mqtt.keep_alive = 60
    @client_mqtt.client_id = "#{ENV['MQTT_CLIENT_ID']}_#{rand(1001)}"
    @client_mqtt.connect
  end

  def path_subscribles
    Channel.where('path LIKE ?', '%/ativo%')
           .or(Channel.where('path LIKE ?', '%/terminal_OUT%'))
           .pluck(:path)
  end

  def record_logs(topic, message)
    channel = Channel.find_by(path: topic)
    log = "#{channel.obs}\n#{message.force_encoding('UTF-8')}"
    last_log = log.length > 800 ? log[-800, 800] : log
    channel.update(obs: last_log)
  end

  def handle_message(topic, message)
    time_verify_offline

    if topic.include?('ativo') && message == '1'
      REDIS.set("timeMqtt#{topic}", Time.now.to_s)
    elsif topic.include?('terminal_OUT')
      Log.info("terminal_OUT: #{message}")
      record_logs(topic, message)
    end
  end

  def time_verify_offline
    if Time.now - @@count_verify > 30
      MqttOffline.verify
      @@count_verify = Time.now
    end
  end
end

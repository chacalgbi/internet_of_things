# frozen_string_literal: true

class MqttOffline
  def self.verify
    if MqttConnectJob.mqtt_client.connected?
      keys = RedisClient.all_keys
      # Log.info("#{Time.now} Redis: #{keys}")

      keys.each do |key|
        if key.include?('timeMqtt')
          time = Time.parse(RedisClient.get(key))
          compare_time(key, time)
        end
      end
    else
      Log.error('MQTT: Desconectado!')
      MqttConnectJob.perform_later
    end
  end

  def self.compare_time(key, time)
    difference = Time.now - time

    if difference > ENV['OFFLINE_SECONDS'].to_i
      parse1 = key.gsub('timeMqtt', '')
      parse2 = parse1.gsub('ativo', 'terminal_OUT')
      formatted_time = Time.now.strftime('%d\%m\%Y %H:%M')

      MqttConnectJob.mqtt_client.publish(parse2, "#{formatted_time} Offline")
      Log.info("#{Time.now} OFFLINE: #{parse1}")
      RedisClient.del(key)
    end
  end
end

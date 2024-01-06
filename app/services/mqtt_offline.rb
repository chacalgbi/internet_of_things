# frozen_string_literal: true

class MqttOffline
  def self.verify
    keys = REDIS.keys

    Log.info("QTD DE KEYS NO REDIS: #{keys.count}")

    keys.each do |key|
      if key.include?('timeMqtt')
        time = Time.parse(REDIS.get(key))
        compare_time(key, time)
      end
    end
  end

  def self.compare_time(key, time)
    difference = Time.now - time

    if difference > ENV['OFFLINE_SECONDS'].to_i
      parse1 = key.gsub('timeMqtt', '')
      parse2 = parse1.gsub('ativo', 'terminal_OUT')
      formatted_time = Time.now.strftime('%d\%m\%Y %H:%M')
      Log.alert("DEVICE OFFLINE #{parse1}")
      REDIS.del(key)

      record_logs(parse2, "#{formatted_time} Offline")
    end
  end

  def self.record_logs(topic, message)
    channel = Channel.find_by(path: topic)
    log = "#{channel.obs}\n#{message.force_encoding('UTF-8')}"
    last_log = log.length > 800 ? log[-800, 800] : log
    channel.update(obs: last_log)
  end
end

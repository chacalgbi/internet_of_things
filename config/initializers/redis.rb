# frozen_string_literal: true

module RedisConnection
  def self.client
    begin
      Log.info('Redis: Conectando ao Redis...')
      Log.info("Redis: host: #{ENV['REDIS_HOST']} - port: #{ENV['REDIS_PORT']}")
      @client ||= Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
    rescue StandardError => e
      Log.error("Redis: Erro ao conectar: #{e.message}")
      Log.error(e.backtrace.join("\n"))
    end
  end
end

# frozen_string_literal: true

module RedisConnection
  def self.client
    Log.info('Redis: Conectando ao Redis...')
    Log.info("Redis: host: #{ENV['REDIS_HOST']} - port: #{ENV['REDIS_PORT']}")
    @client ||= Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
  end
end

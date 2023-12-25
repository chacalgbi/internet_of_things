# frozen_string_literal: true

module RedisConnection
  def self.client
    @client ||= Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
  end
end

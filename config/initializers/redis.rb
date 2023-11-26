# frozen_string_literal: true

module RedisConnection
  def self.client
    @client ||= Redis.new(host: 'localhost', port: 6380)
  end
end

# frozen_string_literal: true
Rails.application.config.after_initialize do

  require "redis"

  class RedisClient
    Log.info("Conectando ao Redis... HOST: #{ENV['REDIS_HOST']} PORT: #{ENV['REDIS_PORT']}")
    @@redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])

    def self.set(key, value)
      @@redis.set(key, value)
    end

    def self.get(key)
      @@redis.get(key)
    end

    def self.del(key)
      @@redis.del(key)
    end

    def self.all_keys
      @@redis.keys('*')
    end

  end

end

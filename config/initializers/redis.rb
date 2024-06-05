# frozen_string_literal: true

REDIS = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])

# frozen_string_literal: true

require 'singleton'

class MqttClient
  include Singleton
  attr_accessor :client

  def configure(client)
    @client = client
  end
end

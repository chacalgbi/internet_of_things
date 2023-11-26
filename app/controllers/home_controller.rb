# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def list
    binding.pry
    # MqttConnectJob.mqtt_client.publish('/mini_monit/device4550/terminal_OUT', "Testando #{Time.now}")
  end
end

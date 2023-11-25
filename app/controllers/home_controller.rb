# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def list
    MqttConnectJob.perform_later
  end
end

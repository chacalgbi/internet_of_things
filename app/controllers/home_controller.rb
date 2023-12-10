# frozen_string_literal: true

class HomeController < LoggedController
  def index
    @client = Client.find_by(email: current_user.email)
    redirect_to register_device_path if @client.nil?

    @devices = Device.where(client_id: @client.id)
    @channels = Channel.where(client_id: @client.id)
  end
end

# frozen_string_literal: true

class HomeController < LoggedController
  def index
    @client = Client.find_by(email: current_user.email)
    if @client.nil?
      redirect_to register_device_path
    else
      @devices = Device.where(client_id: @client.id)
      @channels = Channel.where(client_id: @client.id)
      @ch = object_of_channels(@channels)
      @show = @devices.count == 1 ? 'show' : ''

    end
  end

  def others
    @data_response = nil
    @error = false
    @message = nil

    @data_response = case params['param1']
                     when 'objCliente'
                       data_from_client(params['param2'])
                     when 'clear_log'
                       clear_log(params['param2'])
                     else
                       'Teste de default'
                     end

    render json: { error: @error, message: @message, data: @data_response }
  end

  private

  def object_of_channels(channels)
    count = 0
    types = {}
    channels.each do |channel|
      if channel.tipo == 'led'
        count += 1
        types["#{channel.tipo}#{count}"] = channel
      else
        types[channel.tipo] = channel
      end
    end
    types
  end

  def data_from_client(client_id)
    client = Client.find(client_id)
    devices = Device.where(client_id:)
    channels = Channel.where(client_id:)
    {
      client:,
      devices:,
      channels:
    }
  rescue StandardError => e
    @error = true
    @message = e.message
  end

  def clear_log(id)
    channel = Channel.find(id)
    channel.obs = ''
    channel.save!
  rescue StandardError => e
    @error = true
    @message = e.message
  end
end

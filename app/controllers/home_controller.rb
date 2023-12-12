# frozen_string_literal: true

class HomeController < LoggedController
  def index
    @client = Client.find_by(email: current_user.email)
    if @client.nil?
      redirect_to register_device_path
    else
      @devices = Device.where(client_id: @client.id)
      @channels = Channel.where(client_id: @client.id)
      @show = @devices.count == 1 ? 'show' : ''

    end
  end

  def others
    @data_response = nil

    @data_response = case params['param1']
                     when 'objCliente'
                       data_from_client(params['param2'])
                     when 'teste1'
                       'Teste de teste1'
                     else
                       'Teste de default'
                     end

    render json: { error: false, data: @data_response }
  end

  private

  def data_from_client(client_id)
    client = Client.find(client_id)
    devices = Device.where(client_id:)
    channels = Channel.where(client_id:)
    {
      client:,
      devices:,
      channels:
    }
  end
end

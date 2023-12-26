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
    @error = false
    @message = nil

    @data_response = case params['param1']
                     when 'objCliente'
                       data_from_client(params['param2'])
                     when 'clear_log'
                       clear_log(params['param2'])
                     when 'change_name_device'
                       change_name_device(params['param2'])
                     when 'rele'
                       rele(params['param2'])
                     else
                       'Teste de default'
                     end

    render json: { error: @error, message: @message, data: @data_response }
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
  rescue StandardError => e
    @error = true
    @message = e.message
  end

  def clear_log(id)
    Channel.find(id).update!(obs: '')
    @message = 'Log limpo com sucesso!'
    nil
  rescue StandardError => e
    @error = true
    @message = e.message
  end

  def change_name_device(params)
    Device.find(params['id']).update!(description: params['description'])
    @message = "Nome alterado para '#{params['description']}'"
    { id: params['id'], description: params['description'] }
  rescue ActiveRecord::RecordNotFound
    @error = true
    @message = 'Device não encontrado!'
  rescue ActiveRecord::RecordInvalid
    @error = true
    @message = 'Falha ao atualizar o device!'
  rescue StandardError => e
    @error = true
    @message = e.message
  end

  def rele(params)
    Channel.find(params['id_channel']).update!(previous_state: params['previous_state'])
    nil
  rescue ActiveRecord::RecordNotFound
    @error = true
    @message = 'Channel não encontrado!'
  rescue ActiveRecord::RecordInvalid
    @error = true
    @message = 'Falha ao atualizar o Channel!'
  rescue StandardError => e
    @error = true
    @message = e.message
  end
end

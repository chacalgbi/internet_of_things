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
    @param = params['param2']

    @data_response = case params['param1']
                     when 'objCliente'
                       data_from_client(@param)
                     when 'clear_log'
                       clear_log(@param)
                     when 'change_name_device'
                       change_name_device(@param)
                     when 'rele'
                       rele(@param)
                     when 'chart'
                       chart(@param)
                     else
                       'Teste de default'
                     end

    render json: { error: @error, message: @message, data: @data_response }
  end

  def info
    render json: { memory: memory_string, cpu: cpu_string, disk: disk_string, paths: redis_paths, pm2: pm2_list }
  rescue StandardError => e
    render json: { memory: 'Error', cpu: e.class, disk: e.message }
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

  def memory_string
    lines = `free -h`.gsub!('Gi', 'Gb').split("\n")
    memory_line = lines[1].split

    "MEMÓRIA: Total: #{memory_line[1]} - Usado: #{memory_line[2]} - Livre: #{memory_line[6]}"
  end

  def cpu_string
    lines = `mpstat`.split("\n")
    cpu_line = lines[3].split

    "CPU:    Usuário: #{cpu_line[2]}% - Sistema: #{cpu_line[4]}% - Livre: #{cpu_line[11]}%"
  end

  def disk_string
    lines = `df -h /home`.split("\n")
    disk_line = lines[1].split

    "DISCO:   Total: #{disk_line[1]} - Usado: #{disk_line[2]}(#{disk_line[4]}) - Livre: #{disk_line[3]}"
  end

  def chart(params)
    REDIS.get(params)
  end

  def redis_paths
    JSON.parse(REDIS.get('paths'))
  end

  def pm2_list
    `pm2 list`.split("\n")
  end
end

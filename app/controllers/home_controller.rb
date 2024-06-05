# frozen_string_literal: true

require 'httparty'

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
  rescue StandardError => e
    build_error(e, params.inspect)
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
                     when 'telegram_alert'
                       telegram_alert(@param)
                     when 'text_alert'
                       text_alert(@param)
                     else
                       'Teste de default'
                     end

    render json: { error: @error, message: @message, data: @data_response }
  rescue StandardError => e
    build_error(e, params.inspect)
  end

  def info
    render json: { memory: memory_string, cpu: cpu_string, disk: disk_string, paths: redis_paths, node_server: node_process }
  rescue StandardError => e
    build_error(e, params.inspect)
    render json: { memory: 'Error', cpu: e.class, disk: e.message }
  end

  private

  def build_error(err, params = nil)
    error = "#{self.class} | #{err.class} | #{err.message} | #{err.backtrace.take(1).join("\n").sub(%r{.*internet_of_things/}, '')}"
    Log.error(error, params)
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
    Channel.find(id).update!(obs: '')
    @message = 'Log limpo com sucesso!'
    nil
  rescue StandardError => e
    build_error(e, "clear_log. ID: #{id}")
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
    build_error(e, params.inspect)
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
    build_error(e, params.inspect)
    @error = true
    @message = e.message
  end

  def memory_string
    lines = `free -h`.gsub!('Gi', 'Gb').split("\n")
    memory_line = lines[1].split

    "MEMÓRIA: Total: #{memory_line[1]} - Usado: #{memory_line[2]} - Livre: #{memory_line[6]}"
  rescue StandardError => e
    build_error(e, 'memory_string')
    "ERROR memory_string #{e.message}"
  end

  def cpu_string
    lines = `mpstat`.split("\n")
    cpu_line = lines[3].split

    "CPU:    Usuário: #{cpu_line[2]}% - Sistema: #{cpu_line[4]}% - Livre: #{cpu_line[11]}%"
  rescue StandardError => e
    build_error(e, 'cpu_string')
    "ERROR cpu_string #{e.message}"
  end

  def disk_string
    lines = `df -h /home`.split("\n")
    disk_line = lines[1].split

    "DISCO:   Total: #{disk_line[1]} - Usado: #{disk_line[2]}(#{disk_line[4]}) - Livre: #{disk_line[3]}"
  rescue StandardError => e
    build_error(e, 'disk_string')
    "ERROR disk_string #{e.message}"
  end

  def chart(params)
    REDIS.get(params)
  rescue StandardError => e
    build_error(e, "Chart. Path: #{params}")
    @error = true
    @message = e.message
  end

  def redis_paths
    JSON.parse(REDIS.get('paths'))
  rescue StandardError => e
    build_error(e, 'redis_paths')
    "ERROR redis_paths #{e.message}"
  end

  def node_process
    res = HTTParty.get(
      'http://127.0.0.1:8087/status',
      headers: { 'Content-Type' => 'application/json' }
    )
    JSON.parse(res.body, symbolize_names: true)
  rescue StandardError => e
    build_error(e, 'NodeJs Status')
  end

  def telegram_alert(params)
    text = Channel.find(params)
    res = HTTParty.post(
      'http://127.0.0.1:8087/alertaTelegram',
      body: { 'chat_id' => text.platform, 'msg' => text.obs }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
    resp_obj = JSON.parse(res.body, symbolize_names: true)

    @message = resp_obj[:msg]
    @error = resp_obj[:erroGeral] == 'sim'
    Notify.notification_log('Acionado via WebApp', 'telegram', text.platform, text.obs, resp_obj[:msg])
    nil
  rescue ActiveRecord::RecordNotFound
    @error = true
    @message = 'Channel não encontrado!'
  rescue ActiveRecord::RecordInvalid
    @error = true
    @message = 'Falha ao atualizar o Channel!'
  rescue StandardError => e
    build_error(e, params.inspect)
    @error = true
    @message = e.message
  end

  def text_alert(params)
    Channel.find(params['id']).update!(obs: params['obs'])
    { id: params['id'], obs: params['obs'] }
  rescue ActiveRecord::RecordNotFound
    @error = true
    @message = 'Channel não encontrado!'
  rescue ActiveRecord::RecordInvalid
    @error = true
    @message = 'Falha ao atualizar o Channel!'
  rescue StandardError => e
    build_error(e, params.inspect)
    @error = true
    @message = e.message
  end
end

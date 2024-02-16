# frozen_string_literal: true

require 'httparty'

class IotController < ApplicationController
  include HTTParty
  skip_before_action :verify_authenticity_token, only: %i[device_login mqtt_info telegram whatsapp email telegram_alert]
  before_action :credentials, only: %i[telegram whatsapp email telegram_alert]

  def device_login
    status = 200
    data = {}
    @device = Device.find_by(token: params[:token])
    @config = Config.find_by(tipo: @device.tipo)
    if @device.nil?
      status = 404
      data = { msg: 'Token invalido!', erroGeral: 'sim' }
    else
      data = {
        msg: 'Acesso permitido',
        dados: [@device], # array para manter o padrão de resposta dos dispositivos já em produção
        versao: @config.nil? ? 0.0 : @config['version'].to_f,
        # path_auto_update: @config.nil? ? 'N/A' : @config['path_update'],
        path_auto_update: @config['path_update'],
        id: @device.id,
        nome: @device.description,
        erroGeral: 'nao'
      }
    end
    render json: data, status:
  rescue StandardError => e
    resp_error(e, "Token: #{params[:token]}")
  end

  def mqtt_info
    status = 200
    data = {}
    @client = Client.find(params[:id])
    if @client.nil?
      status = 404
      data = { msg: 'Client_id invalido!', erroGeral: 'sim' }
    else
      array = @client.address_mqtt.split(':')
      data = {
        msg: 'Tokens OK',
        mqtt_user: array[0],
        mqtt_pass: array[1],
        mqtt_server: array[2],
        id: @client.id,
        nome: @client.name,
        erroGeral: 'nao'
      }
    end
    render json: data, status:
  rescue StandardError => e
    resp_error(e, "Client_id: #{params[:id]}")
  end

  def telegram
    response = HTTParty.post(
      'http://127.0.0.1:8087/alertaTelegram',
      body: { 'chat_id' => params['chat_id'], 'msg' => params['msg'] }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    resp_success(response, params['identidade'], 'telegram', params['chat_id'], params['msg'])
  rescue StandardError => e
    resp_error(e, params['identidade'])
    notification_log(params['identidade'], 'telegram', params['chat_id'], params['msg'], e)
  end

  def telegram_alert
    channel = Channel.find_by('path LIKE ? AND device_id = ? AND client_id = ?', '%rele1%', params['device_id'], params['client_id'])

    response = HTTParty.post(
      'http://127.0.0.1:8087/alertaTelegram',
      body: { 'chat_id' => channel.platform, 'msg' => channel.obs }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
    resp_success(response, params['identidade'], 'telegram', channel.platform, channel.obs)
  rescue StandardError => e
    resp_error(e, params['identidade'])
    notification_log(params['identidade'], 'telegram', channel.platform, channel.obs, e)
  end

  def whatsapp
    response = HTTParty.post(
      'http://127.0.0.1:8087/alertaWhatsapp',
      body: { 'cel' => params['cel'], 'msg' => params['msg'] }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    resp_success(response, params['identidade'], 'whatsapp', params['cel'], params['msg'])
  rescue StandardError => e
    resp_error(e, params['identidade'])
    notification_log(params['identidade'], 'whatsapp', params['cel'], params['msg'], e)
  end

  def email
    response = HTTParty.post(
      'http://127.0.0.1:8087/alertaEmail',
      body: { 'email' => params['email'], 'titulo' => params['titulo'], 'corpo' => params['corpo'] }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    resp_success(response, params['identidade'], 'email', params['email'], params['corpo'])
  rescue StandardError => e
    resp_error(e, params['identidade'])
    notification_log(params['identidade'], 'email', params['email'], params['corpo'], e)
  end

  private

  def resp_success(res, identity, channel, recipient, message)
    resp_obj = JSON.parse(res.body, symbolize_names: true)
    data = { msg: resp_obj[:msg], erroGeral: resp_obj[:erroGeral] }

    notification_log(identity, channel, recipient, message, resp_obj[:msg])

    render json: data, status: res.code
  end

  def credentials
    return unless params['userAdmin'] != ENV['USER_ADMIN'] || params['passAdmin'] != ENV['PASS_ADMIN']

    render json: { msg: 'Usuário ou senha inválido!', erroGeral: 'sim' }, status: 401
  end

  def resp_error(err, params = nil)
    error = "#{self.class} | #{err.class} | #{err.message} | #{err.backtrace.take(1).join("\n").sub(%r{.*internet_of_things/}, '')}"
    Log.error(error, params)
    render json: { msg: error, erroGeral: 'sim' }, status: 500
  end

  def notification_log(identity = nil, channel = nil, recipient = nil, message = nil, result = nil) # rubocop:disable Metrics/ParameterLists
    Notification.create!(
      identity: identity || '',
      channel: channel || '',
      recipient: recipient || '',
      message: message || '',
      result: result || ''
    )
  end
end

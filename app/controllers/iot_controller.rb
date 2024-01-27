# frozen_string_literal: true

require 'httparty'

class IotController < ApplicationController
  include HTTParty
  skip_before_action :verify_authenticity_token, only: %i[device_login mqtt_info telegram whatsapp email]
  before_action :credentials, only: %i[telegram whatsapp email]

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
        versao: @config['version'].to_f,
        path_auto_update: @config['path_update'],
        erroGeral: 'nao'
      }
    end
    render json: data, status:
  rescue StandardError => e
    resp_error(e)
  end

  def mqtt_info
    status = 200
    data = {}
    @client = Client.find(params[:id])
    if @client.nil?
      status = 404
      data = { msg: 'id invalido!', erroGeral: 'sim' }
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
    resp_error(e)
  end

  def telegram
    response = HTTParty.post(
      'http://127.0.0.1:8087/alertaTelegram',
      body: { 'chat_id' => params['chat_id'], 'msg' => params['msg'] }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    resp_success(response)
  rescue StandardError => e
    resp_error(e)
  end

  def whatsapp
    response = HTTParty.post(
      'http://127.0.0.1:8087/alertaWhatsapp',
      body: { 'cel' => params['cel'], 'msg' => params['msg'] }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    resp_success(response)
  rescue StandardError => e
    resp_error(e)
  end

  def email
    response = HTTParty.post(
      'http://127.0.0.1:8087/alertaEmail',
      body: { 'email' => params['email'], 'titulo' => params['titulo'], 'corpo' => params['corpo'] }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    resp_success(response)
  rescue StandardError => e
    resp_error(e)
  end

  private

  def resp_success(res)
    resp_obj = JSON.parse(res.body, symbolize_names: true)
    data = { msg: resp_obj[:msg], erroGeral: resp_obj[:erroGeral] }

    render json: data, status: res.code
  end

  def credentials
    return unless params['userAdmin'] != ENV['USER_ADMIN'] || params['passAdmin'] != ENV['PASS_ADMIN']

    render json: { msg: 'Usuário ou senha inválido!', erroGeral: 'sim' }, status: 401
  end

  def resp_error(err)
    error = "#{err.class} - #{err.message}"
    Log.error(error)
    render json: { msg: error, erroGeral: 'sim' }, status: 500
  end
end

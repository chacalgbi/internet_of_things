# frozen_string_literal: true

require 'httparty'

class IotController < ApplicationController
  include HTTParty
  skip_before_action :verify_authenticity_token, only: %i[device_login mqtt_info telegram]
  before_action :credentials, only: %i[telegram]

  def device_login
    status = 200
    data = {}
    @device = Device.find_by(token: params[:token])
    @config = Config.last
    if @device.nil?
      status = 404
      data = { msg: 'Token invalido!', erroGeral: 'sim' }
    else
      data = {
        msg: 'Acesso permitido',
        dados: @device,
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
        msg: 'MQTT info OK',
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
    response = HTTParty.post("#{ENV['TELEGRAM_URL']}#{params['chat_id']}&text=#{params['msg']}")
    resp_obj = JSON.parse(response.body, symbolize_names: true)
    erro = response.code == 200 ? 'nao' : 'sim'
    data = { msg: response.message, erroGeral: erro, body: resp_obj }
    render json: data, status: response.code
  rescue StandardError => e
    resp_error(e)
  end

  private

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

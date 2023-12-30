# frozen_string_literal: true

Rails.application.config.after_initialize do
  Thread.new do
    max_attempts = 5
    attempts = 0
    begin
      Thread.current.name = 'Processo_conexao_mqtt'
      Thread.current.abort_on_exception = true
      MqttSubscrible.new if Rails.env.development? || Rails.env.production?
    rescue StandardError => e
      attempts += 1
      if attempts < max_attempts
        sleep 5
        Log.error("Erro ao conectar ao MQTT: #{e.message}. Tentando novamente")
        retry
      else
        Log.error("Erro ao conectar ao MQTT após #{max_attempts} tentativas. #{e.message}")
      end
    end
  end
end

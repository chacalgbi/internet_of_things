# frozen_string_literal: true

require 'json'

ActiveAdmin.register Channel do # rubocop:disable Metrics/BlockLength
  permit_params :client_id, :device_id, :category, :platform, :path, :tipo, :color, :range, :array_info, :label, :previous_state,
                :obs

  config.per_page = 60

  index pagination_total: false do
    selectable_column
    column :id
    column :client_id do |channel|
      @client ||= Client.all.index_by(&:id)
      client = @client[channel.client_id]
      client ? "#{channel.client_id} #{client.name}" : 'N/A'
    end
    column :device_id do |channel|
      @device ||= Device.all.index_by(&:id)
      device = @device[channel.device_id]
      device ? "#{channel.device_id} #{device.description}" : 'N/A'
    end
    column :category
    column :platform
    column :path
    column :tipo
    column :color
    column :range
    column :array_info
    column :label
    column :previous_state
    column :created_at
    column :updated_at
    actions
  end

  batch_action :Criar_Channels_para_Mini_Monitor, form: { client_id: :text, device_id: :text, path: :text } do |_ids, inputs|
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}ativo", category: 'subscrible',
                   tipo: 'ativo')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}terminal_OUT", category: 'subscrible',
                   tipo: 'terminal_view')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}prefes_OUT", category: 'subscrible',
                   tipo: 'prefes_view')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}update", category: 'publish',
                   tipo: 'update')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}terminal_IN", category: 'publish',
                   tipo: 'terminal_insert')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}prefes_IN", category: 'publish',
                   tipo: 'prefes_insert')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}info", category: 'subscrible',
                   tipo: 'info', color: 'dark')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}vcc1", category: 'subscrible',
                   tipo: 'value', color: 'primary', label: 'Tensão VCC', previous_state: 'Aguardando...')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}reiniciar", category: 'publish',
                   tipo: 'reiniciar', color: 'danger', label: 'Reiniciar Dispositivo', previous_state: '0', range: '0-1', array_info: 'push')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}led2", category: 'subscrible',
                   tipo: 'led', color: 'primary', label: 'Tensão VAC', previous_state: '0', range: '0-1', array_info: 'Falha-OK')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}led1", category: 'subscrible',
                   tipo: 'led', color: 'primary', label: 'Sensor de Abertura', previous_state: '0', range: '0-1', array_info: 'Aberto-Fechado')

    redirect_to collection_path, alert: 'Canais criados com sucesso.'
  end

  batch_action :Criar_Channels_para_Diversos, form: { client_id: :text, device_id: :text, path: :text } do |_ids, inputs|
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}ativo", category: 'subscrible',
                   tipo: 'ativo')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}terminal_OUT", category: 'subscrible',
                   tipo: 'terminal_view')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}update", category: 'publish',
                   tipo: 'update')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}terminal_IN", category: 'publish',
                   tipo: 'terminal_insert')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}info", category: 'subscrible',
                   tipo: 'info', color: 'dark')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}reiniciar", category: 'publish',
                   tipo: 'reiniciar', color: 'danger', label: 'Reiniciar Dispositivo', previous_state: '0', range: '0-1', array_info: 'push')

    redirect_to collection_path, alert: 'Canais criados com sucesso.'
  end

  batch_action :Importar_Channels_do_Sistema_antigo, form: { array_channels: :text } do |_ids, inputs|
    array_channels = inputs['array_channels']
    data = JSON.parse(array_channels)
    alert = "#{data.count} Canais: "

    begin
      Channel.transaction do
        data.each do |channel_data|
          alert += "#{channel_data['tipo']}, "
          Channel.create!(channel_data)
        end
        alert += 'criados com sucesso.'
      end
    rescue StandardError => e
      alert = "Rollback realizado devido ao erro: #{e.class} | #{e.message}"
    end

    redirect_to collection_path, alert:
  end

  batch_action :Alterar_ClientId_e_deviceId, form: { client_id: :text, device_id: :text } do |ids, inputs|
    alert = 'Client e Device atualizados com sucesso.'
    begin
      Channel.transaction do
        Channel.where(id: ids).update_all(client_id: inputs['client_id'], device_id: inputs['device_id'])
      end
    rescue StandardError => e
      alert = "Rollback realizado devido ao erro: #{e.class} | #{e.message}"
    end
    redirect_to collection_path, alert:
  end

  batch_action :Apagar_Channels_Selecionados, confirm: 'Você tem certeza que deseja apagar todos os canais selecionados?' do |ids|
    alert = 'Os canais selecionados foram apagados.'
    begin
      Channel.transaction do
        Channel.where(id: ids).destroy_all
      end
    rescue StandardError => e
      alert = "Rollback realizado devido ao erro: #{e.class} | #{e.message}"
    end
    redirect_to collection_path, alert:
  end

  batch_action :Exportar_Paths_Ativo_e_Vcc_para_Redis, confirm: 'Você tem certeza que deseja exportar todos os Paths Ativo e Vcc para Redis?' do |_ids|
    alert = ''
    begin
      paths = Channel.where('path LIKE ? OR path LIKE ?', '%ativo%', '%vcc%').pluck(:path)
      REDIS.set('paths', paths.to_json)
      alert = "#{paths.count} Paths exportados com sucesso."
    rescue StandardError => e
      alert = "Erro ao processar os paths: #{e.class} | #{e.message}"
    end
    redirect_to collection_path, alert:
  end

  form do |f|
    f.inputs do
      f.input :client_id, as: :select, collection: Client.all.map { |client| [client.name, client.id] }
      f.input :device_id, as: :select, collection: Device.all.map { |device| [device.description, device.id] }
      f.input :category, as: :select, collection: %w[subscrible publish]
      f.input :platform
      f.input :path
      f.input :tipo, as: :select,
                     collection: %w[ativo button info led slide terminal_insert terminal_view update reiniciar value prefes_insert prefes_view update]
      f.input :color, as: :select, collection: %w[primary secondary success danger warning info light dark]
      f.input :range
      f.input :array_info
      f.input :label
      f.input :previous_state
      f.input :obs
    end
    f.actions
  end
end

# frozen_string_literal: true

ActiveAdmin.register Channel do
  permit_params :client_id, :device_id, :category, :platform, :path, :tipo, :color, :range, :array_info, :label, :previous_state,
                :obs

  index do
    selectable_column
    column :id
    column :client_id
    column :device_id
    column :category
    column :platform
    column :path
    column :tipo
    column :color
    column :range
    column :array_info
    column :label
    column :previous_state
    column :obs
    column :created_at
    column :updated_at
    actions
  end

  batch_action :Criar_Channels_para_Mini_Monitor, form: { client_id: :text, device_id: :text, path: :text } do |_ids, inputs|
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}ativo", category: 'subscribe',
                   tipo: 'ativo')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}terminal_OUT", category: 'subscribe',
                   tipo: 'terminal_view')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}prefes_OUT", category: 'subscribe',
                   tipo: 'prefes_view')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}update", category: 'publish',
                   tipo: 'update')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}terminal_IN", category: 'publish',
                   tipo: 'terminal_insert')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}prefes_IN", category: 'publish',
                   tipo: 'prefes_insert')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}info", category: 'subscribe',
                   tipo: 'info', color: 'dark')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}vcc1", category: 'subscrible',
                   tipo: 'value', color: 'primary', label: 'Tensão VCC 1', previous_state: 'Aguardando...')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}reiniciar", category: 'publish',
                   tipo: 'reiniciar', color: 'danger', label: 'Reiniciar Dispositivo', previous_state: '0', range: '0-1', array_info: 'push')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}led2", category: 'subscrible',
                   tipo: 'led', color: 'primary', label: 'Tensão VAC', previous_state: '0', range: '0-1', array_info: 'OK-Falha')
    Channel.create(client_id: inputs['client_id'], device_id: inputs['device_id'], path: "#{inputs['path']}led1", category: 'subscrible',
                   tipo: 'led', color: 'primary', label: 'Sensor de Abertura', previous_state: '0', range: '0-1', array_info: 'Aberto-Fechado')

    redirect_to collection_path, alert: 'Canais criados com sucesso.'
  end

  form do |f|
    f.inputs do
      f.input :client_id, as: :select, collection: Client.all.map { |client| [client.name, client.id] }
      f.input :device_id, as: :select, collection: Device.all.map { |device| [device.description, device.id] }
      f.input :category, as: :select, collection: %w[subscribe publish]
      f.input :platform
      f.input :path
      f.input :tipo, as: :select,
                     collection: %w[ativo button info led slide terminal_insert terminal_view update value prefes_insert prefes_view update]
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

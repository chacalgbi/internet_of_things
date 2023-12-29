# frozen_string_literal: true

ActiveAdmin.register Device do
  permit_params :description, :device, :token, :tipo, :versao, :linkAjuda, :pathUpdate, :obs, :client_id

  index do
    selectable_column
    column :id
    column :client_id
    column :description
    column :device
    column :token
    column :tipo
    column :versao
    column :linkAjuda
    column :pathUpdate
    column :obs
    column :created_at
    column :updated_at
    actions
  end

  batch_action :Importar_Devices_do_Sistema_antigo, form: { array_devices: :text } do |_ids, inputs|
    array_devices = inputs['array_devices']
    data = JSON.parse(array_devices)
    alert = "#{data.count} Devices: "

    begin
      Device.transaction do
        data.each do |device_data|
          alert += "#{device_data['description']}, "
          Device.create!(device_data)
        end
        alert += 'criados com sucesso.'
      end
    rescue StandardError => e
      alert = "Rollback realizado devido ao erro: #{e.class} | #{e.message}"
    end

    redirect_to collection_path, alert:
  end

  form do |f|
    f.inputs do
      f.input :client_id, as: :select, collection: Client.all.map { |client| [client.name, client.id] }
      f.input :description
      f.input :device
      f.input :token
      f.input :tipo, as: :select, collection: %w[mini_monit diversos]
      f.input :versao
      f.input :linkAjuda
      f.input :pathUpdate
      f.input :obs
    end
    f.actions
  end
end

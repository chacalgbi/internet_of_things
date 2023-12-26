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

  form do |f|
    f.inputs do
      f.input :client_id, as: :select, collection: Client.all.map { |client| [client.name, client.id] }
      f.input :description
      f.input :device
      f.input :token
      f.input :tipo
      f.input :versao
      f.input :linkAjuda
      f.input :pathUpdate
      f.input :obs
    end
    f.actions
  end
end

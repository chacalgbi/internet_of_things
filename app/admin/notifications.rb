# frozen_string_literal: true

ActiveAdmin.register Notification do
  permit_params :identity, :channel, :recipient, :message, :result

  config.per_page = 60

  index pagination_total: false do
    selectable_column
    column :id
    column :identity
    column :channel
    column :recipient
    column :message
    column :result
    column :created_at
    actions defaults: false do |notification|
      link_to 'Remover', admin_notification_path(notification), method: :delete
    end
  end
end

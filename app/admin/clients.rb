# frozen_string_literal: true

ActiveAdmin.register Client do
  permit_params :name, :email, :cel, :address_mqtt, :obs
end

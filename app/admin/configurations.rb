# frozen_string_literal: true

ActiveAdmin.register Configuration do
  permit_params :version

  index do
    selectable_column
    column :id
    column :version
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :version
    end
    f.actions
  end
end

# frozen_string_literal: true

ActiveAdmin.register Config do
  permit_params :version, :path_update

  index do
    selectable_column
    column :id
    column :version
    column :path_update
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :version
      row :path_update
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :version
      f.input :path_update
    end
    f.actions
  end
end

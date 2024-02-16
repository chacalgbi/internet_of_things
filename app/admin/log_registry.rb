# frozen_string_literal: true

ActiveAdmin.register LogRegistry do
  permit_params :classe, :classe_error, :message, :level, :backtrace, :params

  index do
    selectable_column
    column :id
    column :params
    column :classe
    column :classe_error
    column :message
    column :level
    column :backtrace
    column :created_at
  end
end

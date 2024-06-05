class AddResultToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :result, :string
  end
end

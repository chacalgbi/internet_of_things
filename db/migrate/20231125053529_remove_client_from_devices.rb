class RemoveClientFromDevices < ActiveRecord::Migration[7.1]
  def change
    remove_reference :devices, :client, null: false, foreign_key: true
  end
end

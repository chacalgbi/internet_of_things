class AddClientIdToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :client_id, :integer
  end
end

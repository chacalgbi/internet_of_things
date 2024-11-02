class AddLastOfflineToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :last_offline, :string
  end
end

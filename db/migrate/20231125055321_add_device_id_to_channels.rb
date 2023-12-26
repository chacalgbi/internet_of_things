class AddDeviceIdToChannels < ActiveRecord::Migration[7.1]
  def change
    add_column :channels, :device_id, :integer
  end
end

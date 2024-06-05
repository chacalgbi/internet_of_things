class RemoveDeviceFromChannels < ActiveRecord::Migration[7.1]
  def change
    remove_reference :channels, :device, null: false, foreign_key: true
  end
end

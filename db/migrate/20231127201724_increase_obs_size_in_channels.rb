class IncreaseObsSizeInChannels < ActiveRecord::Migration[7.1]
  def change
    change_column :channels, :obs, :string, limit: 850
  end
end

class RenameTypeInChannels < ActiveRecord::Migration[7.1]
  def change; end
  rename_column :channels, :type, :tipo
end

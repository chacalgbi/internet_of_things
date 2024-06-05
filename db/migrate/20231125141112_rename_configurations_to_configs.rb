class RenameConfigurationsToConfigs < ActiveRecord::Migration[7.1]
  def change
    rename_table :configurations, :configs
  end
end

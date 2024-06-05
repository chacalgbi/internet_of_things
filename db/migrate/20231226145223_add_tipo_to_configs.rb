class AddTipoToConfigs < ActiveRecord::Migration[7.1]
  def change
    add_column :configs, :tipo, :string
  end
end

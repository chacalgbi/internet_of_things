class ChangeVersionToBeDecimalInConfigs < ActiveRecord::Migration[7.1]
  def up
    change_column :configs, :version, :decimal, precision: 3, scale: 2
  end

  def down
    change_column :configs, :version, :string
  end
end

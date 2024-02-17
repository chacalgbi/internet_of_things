class AddConfigsAndDevedorToDevice < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :configs, :string
    add_column :devices, :devedor, :string, default: 'nao'
  end
end

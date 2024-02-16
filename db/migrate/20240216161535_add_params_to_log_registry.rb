class AddParamsToLogRegistry < ActiveRecord::Migration[7.1]
  def change
    add_column :log_registries, :params, :string
  end
end

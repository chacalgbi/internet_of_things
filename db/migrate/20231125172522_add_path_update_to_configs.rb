# frozen_string_literal: true

class AddPathUpdateToConfigs < ActiveRecord::Migration[7.1]
  def change
    add_column :configs, :path_update, :string
  end
end

# frozen_string_literal: true

class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices do |t|
      t.string :description
      t.string :device
      t.string :token
      t.string :tipo
      t.string :versao
      t.string :linkAjuda
      t.string :pathUpdate
      t.string :obs, limit: 500
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end

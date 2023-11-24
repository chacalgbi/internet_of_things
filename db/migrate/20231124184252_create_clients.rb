# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :cel
      t.string :address_mqtt
      t.string :obs, limit: 500

      t.timestamps
    end
  end
end

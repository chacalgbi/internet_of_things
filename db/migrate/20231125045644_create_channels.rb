class CreateChannels < ActiveRecord::Migration[7.1]
  def change
    create_table :channels do |t|
      t.bigint :client_id
      t.string :category
      t.string :platform
      t.string :path
      t.string :type
      t.string :color
      t.string :range
      t.string :array_info
      t.string :label
      t.string :previous_state
      t.string :obs, limit: 500
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end

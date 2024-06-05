class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :identity
      t.string :channel
      t.string :recipient
      t.string :message

      t.timestamps
    end
  end
end

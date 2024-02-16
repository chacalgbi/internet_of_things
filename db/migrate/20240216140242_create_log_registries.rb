class CreateLogRegistries < ActiveRecord::Migration[7.1]
  def change
    create_table :log_registries do |t|
      t.string :classe
      t.string :classe_error
      t.string :message
      t.string :level
      t.text :backtrace

      t.timestamps
    end
  end
end

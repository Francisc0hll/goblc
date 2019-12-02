class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.text :message
      t.string :link
      t.string :rut

      t.timestamps
    end
  end
end

class CreateMonitorTable < ActiveRecord::Migration[5.0]
  def change
    create_table :totem_monitors do |t|
      t.string :totem_tid, null: false
      t.string :message, null:false
      t.integer :code, null: false
      t.timestamp :ping_time, null: false
      t.timestamps
    end
  end
end

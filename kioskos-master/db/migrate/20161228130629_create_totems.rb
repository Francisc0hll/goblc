class CreateTotems < ActiveRecord::Migration[5.0]
  def change
    create_table :totems do |t|
    	t.string :tid, null: false
      t.string :password_digest, null: false
      t.boolean :active, null: false, default: false
      t.string :location

      t.timestamps
    end
  end
end

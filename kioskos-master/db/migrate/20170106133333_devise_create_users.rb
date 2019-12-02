class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :rut, null: false
      t.string :token, null: false

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip
      t.references :current_totem, index: true, references: :totems
      t.references :last_totem, index: true, references: :totems

      t.timestamps null: false
    end

    add_index :users, :rut, unique: true
  end
end

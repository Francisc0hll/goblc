class CreateAuthenticationsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.string :auth_type
      t.string :minucia
      t.integer :finger
      t.string :signature
      t.references :user
    end
  end
end

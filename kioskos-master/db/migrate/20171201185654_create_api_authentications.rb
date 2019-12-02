class CreateApiAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :api_authentications do |t|
      t.string :token
      t.integer :expires_in
      t.string :token_type

      t.timestamps
    end
  end
end

class CreateClaveUnicaPetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :clave_unica_petitions do |t|
      t.string :rut
      t.string :status, default: 'requested'
      t.string :method
      t.string :phone
      t.string :email
      t.references :totem

      t.timestamps
    end
  end
end

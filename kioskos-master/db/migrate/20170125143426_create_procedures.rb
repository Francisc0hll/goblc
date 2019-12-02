class CreateProcedures < ActiveRecord::Migration[5.0]
  def change
    create_table :procedures do |t|
      t.integer :procedure_id
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.boolean :active_in_totem, default: false
      t.string :security

      t.timestamps
    end
  end
end

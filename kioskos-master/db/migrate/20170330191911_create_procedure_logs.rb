class CreateProcedureLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :procedure_logs do |t|
      t.string :name
      t.integer :chileatiende_id
      t.references :totem, foreign_key: true

      t.timestamps
    end
  end
end

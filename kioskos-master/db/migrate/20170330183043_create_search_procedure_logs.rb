class CreateSearchProcedureLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :search_procedure_logs do |t|
      t.string :search
      t.boolean :found
      t.text :results
      t.references :totem

      t.timestamps
    end
  end
end

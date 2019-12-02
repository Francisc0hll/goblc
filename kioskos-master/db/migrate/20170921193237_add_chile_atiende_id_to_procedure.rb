class AddChileAtiendeIdToProcedure < ActiveRecord::Migration[5.0]
  def change
    add_column :procedures, :chile_atiende_id, :integer
  end
end

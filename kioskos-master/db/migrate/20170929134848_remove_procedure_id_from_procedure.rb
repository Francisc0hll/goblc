class RemoveProcedureIdFromProcedure < ActiveRecord::Migration[5.0]
  def change
    remove_column :procedures, :procedure_id
  end
end

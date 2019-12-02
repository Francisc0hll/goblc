class AddTypeOfProcedureToProcedure < ActiveRecord::Migration[5.0]
  def change
    add_column :procedures, :type_of_procedure, :string, after: :security
  end
end

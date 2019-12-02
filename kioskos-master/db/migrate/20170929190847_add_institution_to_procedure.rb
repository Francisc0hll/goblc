class AddInstitutionToProcedure < ActiveRecord::Migration[5.0]
  def change
    add_reference :procedures, :institution, foreign_key: true
  end
end

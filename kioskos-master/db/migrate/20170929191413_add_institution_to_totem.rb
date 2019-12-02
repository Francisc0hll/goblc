class AddInstitutionToTotem < ActiveRecord::Migration[5.0]
  def change
    add_reference :totems, :institution, foreign_key: true
  end
end

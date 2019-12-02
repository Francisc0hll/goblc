class AddInstitutionToAdminUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :admin_users, :institution, foreign_key: true
  end
end

class SetInstitutionToAdminUsers < ActiveRecord::Migration[5.0]
  def up
    execute "UPDATE admin_users SET institution_id = (SELECT id FROM institutions WHERE name = 'Ministerio del Test') WHERE institution_id IS NULL;"
  end
  def down
    execute "UPDATE admin_users SET institution_id = NULL WHERE institution_id = (SELECT id FROM institutions WHERE name = 'Ministerio del Test');"
  end
end

class UpdateAdminType < ActiveRecord::Migration[5.0]
  def up
    execute "UPDATE admin_users SET admin_type='super_admin';"
  end
  def down
    execute "UPDATE admin_users SET admin_type='superadmin';"
  end
end

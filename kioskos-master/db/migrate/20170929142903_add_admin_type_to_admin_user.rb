class AddAdminTypeToAdminUser < ActiveRecord::Migration[5.0]
  def change
    add_column :admin_users, :admin_type, :string
    AdminUser.all.each do |admin|
      admin.update(admin_type: "superadmin")
    end
  end
end

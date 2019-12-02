class RemoveTotemSesionColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :totems, :sign_in_count
    remove_column :totems, :last_sign_in_at
    remove_column :totems, :current_sign_in_at
    remove_column :totems, :last_sign_in_ip
    remove_column :totems, :current_sign_in_ip
  end
end

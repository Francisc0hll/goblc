class AddUserInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string, default: false
    add_column :users, :email, :string, default: false
  end
end

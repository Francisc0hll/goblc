class AddNameLastNameFatherLastNameMotherToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_name_father, :string
    add_column :users, :last_name_mother, :string
  end
end

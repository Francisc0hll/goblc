class AddTotemToAuthentification < ActiveRecord::Migration[5.0]
  def change
    add_reference :authentications, :totem, index: true
  end
end

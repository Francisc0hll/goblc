class AddCreatedAtToAuthentication < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :created_at, :datetime
  end
end

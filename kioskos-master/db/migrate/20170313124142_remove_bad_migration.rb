class RemoveBadMigration < ActiveRecord::Migration[5.0]
  def change
    unless column_exists?(:totems, :password_digest)
      add_column :totems, :password_digest, :string, after: :tid
    end
  end
end

class AddStatusToCertificate < ActiveRecord::Migration[5.0]
  def change
    add_column :certificates, :status, :string, default: 'requested'
  end
end

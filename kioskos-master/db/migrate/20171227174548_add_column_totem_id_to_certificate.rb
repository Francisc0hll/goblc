class AddColumnTotemIdToCertificate < ActiveRecord::Migration[5.0]
  def change
    add_column :certificates, :totem_id, :string
  end
end

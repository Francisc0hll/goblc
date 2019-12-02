class AddRutToTotem < ActiveRecord::Migration[5.0]
  def change
    add_column :totems, :rut, :string, null: false, default: 0
  end
end

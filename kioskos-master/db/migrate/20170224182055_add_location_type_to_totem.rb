class AddLocationTypeToTotem < ActiveRecord::Migration[5.0]
  def change
    add_column :totems, :location_type, :string, after: :location
  end
end

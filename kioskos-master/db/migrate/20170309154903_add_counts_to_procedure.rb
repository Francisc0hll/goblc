class AddCountsToProcedure < ActiveRecord::Migration[5.0]
  def change
    add_column :procedures, :request_count, :integer, default: 0
    add_column :procedures, :delivery_count, :integer, default: 0
  end
end

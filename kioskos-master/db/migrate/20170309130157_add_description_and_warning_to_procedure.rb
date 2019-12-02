class AddDescriptionAndWarningToProcedure < ActiveRecord::Migration[5.0]
  def change
    add_column :procedures, :description, :text
    add_column :procedures, :info, :string
    add_column :procedures, :warning, :string
  end
end

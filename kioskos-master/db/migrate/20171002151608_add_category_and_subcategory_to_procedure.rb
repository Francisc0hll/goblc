class AddCategoryAndSubcategoryToProcedure < ActiveRecord::Migration[5.0]
  def change
    add_column :procedures, :category, :string
    add_column :procedures, :subcategory, :string
  end
end

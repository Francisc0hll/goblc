class AddPrinterConfigToTotem < ActiveRecord::Migration[5.0]
  def change
    add_column :totems, :has_printer, :boolean, default: true
  end
end

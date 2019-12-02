class AddCountryCodeTotem < ActiveRecord::Migration[5.0]
  def change
    add_column :totems, :country_phone_code, :int
  end
end

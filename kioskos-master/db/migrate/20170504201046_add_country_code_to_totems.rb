class AddCountryCodeToTotems < ActiveRecord::Migration[5.0]
  def change
    Totem.where(country_phone_code: nil).update_all(country_phone_code: '+56')
  end
end

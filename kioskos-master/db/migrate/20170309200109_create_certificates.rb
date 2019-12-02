class CreateCertificates < ActiveRecord::Migration[5.0]
  def change
    create_table :certificates do |t|
      t.references :procedure
      t.string :rut
      t.string :email

      t.timestamps
    end
  end
end

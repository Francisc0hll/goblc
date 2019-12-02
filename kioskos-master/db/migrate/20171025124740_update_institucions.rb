class UpdateInstitucions < ActiveRecord::Migration[5.0]
  def up
    execute "UPDATE institutions SET name='Minsegpres' where name='Segpres';"
    execute "UPDATE procedures SET institution_id = (SELECT id FROM institutions WHERE name='Minsegpres') WHERE institution_id IS NULL;"
  end
  def down
    execute "UPDATE procedures SET institution_id = NULL WHERE institution_id = (SELECT id FROM institutions WHERE name='MinSegpres');"
    execute "UPDATE institutions SET name='Segpres' where name='Minsegpres';"
  end
end

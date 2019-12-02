class AssignTotemToAuthentification < ActiveRecord::Migration[5.0]
  def change
    t = Totem.last
    Authentication.update_all(totem_id: t.id) if t.present?
  end
end

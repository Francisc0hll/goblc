class ChangeTotemName < ActiveRecord::Migration[5.0]
  def change
    t = Totem.first
    t.update_column(:tid, '1IPS') if t.present?
  end
end

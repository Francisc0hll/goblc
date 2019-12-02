class UpdateTotemMonitors < ActiveRecord::Migration[5.0]
  def change
    remove_column :totem_monitors, :code
    remove_column :totem_monitors, :message
  end
end

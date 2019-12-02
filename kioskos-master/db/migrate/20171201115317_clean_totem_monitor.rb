class CleanTotemMonitor < ActiveRecord::Migration[5.0]
  def change
    execute 'DELETE FROM totem_monitors;'
  end
end

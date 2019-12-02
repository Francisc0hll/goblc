class RenameLinkToChileAtiendeIdInNotification < ActiveRecord::Migration[5.0]
  def change
    rename_column :notifications, :link, :chile_atiende_id
  end
end

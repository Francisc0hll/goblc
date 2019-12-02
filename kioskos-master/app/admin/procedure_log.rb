ActiveAdmin.register ProcedureLog do
  menu parent: I18n.t('active_admin.logs')

  actions :index, :show

  controller do
    def scoped_collection
      ProcedureLog.includes(:totem)
    end
  end

  index do
    selectable_column
    column :totem_id do |i|
      i.totem.tid
    end
    column :name
    column :chileatiende_id
    column :created_at
    actions
  end

  filter :totem_tid, as: :string
  filter :name
  filter :chileatiende_id
  filter :created_at

  show do
    attributes_table do
      row :name
      row :chileatiende_id
      row :totem_id do |i|
        i.totem.tid
      end
      row :created_at
    end
    active_admin_comments
  end
end

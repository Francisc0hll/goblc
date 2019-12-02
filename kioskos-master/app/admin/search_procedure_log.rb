ActiveAdmin.register SearchProcedureLog do
  menu parent: I18n.t('active_admin.logs')

  actions :index, :show

  controller do
    def scoped_collection
      SearchProcedureLog.includes(:totem)
    end
  end

  index row_class: -> record { record.found } do
    selectable_column
    column :totem_id do |i|
      i.totem.tid
    end
    column :search
    column :found
    column :results
    column :created_at
    actions
  end

  filter :totem_tid, as: :string
  filter :search
  filter :found
  filter :created_at

  show do
    attributes_table do
      row :search
      row :totem_id do |i|
        i.totem.tid
      end
      row :found
      row :results
      row :created_at
    end
    active_admin_comments
  end
end

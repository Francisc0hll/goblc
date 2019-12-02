ActiveAdmin.register ClaveUnicaPetition do
  menu parent: I18n.t('active_admin.logs')

  actions :index, :show

  controller do
    def scoped_collection
      ClaveUnicaPetition.includes(:totem)
    end
  end

  index row_class: -> record { record.status } do
    selectable_column
    column :totem_id do |i|
      i.totem.tid
    end
    column :status
    column :method
    column :rut
    column :email
    column :phone
    actions
  end

  filter :totem_tid, as: :string
  filter :rut
  filter :email
  filter :method,
    as: :select,
    collection: proc { ClaveUnicaPetition::METHODS }
  filter :status,
    as: :select,
    collection: proc { ClaveUnicaPetition::STATUS }
  filter :created_at

  show do
    attributes_table do
      row :rut
      row :totem_id do |i|
        i.totem.tid
      end
      row :email
      row :phone
      row :created_at
    end
    active_admin_comments
  end
end

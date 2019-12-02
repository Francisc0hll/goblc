ActiveAdmin.register Certificate do
  menu parent: I18n.t('active_admin.logs')

  actions :index, :show

  controller do
    def scoped_collection
      Certificate.includes(:procedure)
    end
  end

  index row_class: -> record { record.status } do
    selectable_column
    column :totem_id
    column :procedure_id do |i|
      i.try(:procedure).try(:name)
    end
    column :status
    column :rut
    column :email
    actions
  end
  filter :totem_id, as: :string
  filter :procedure_name, as: :string
  filter :rut
  filter :email
  filter :status,
    as: :select,
    collection: proc { Certificate::STATUS }

  show do
    attributes_table do
      row :rut
      row :procedure_id do |i|
        i.procedure.name
      end
      row :email
      row :created_at
    end
    active_admin_comments
  end
end

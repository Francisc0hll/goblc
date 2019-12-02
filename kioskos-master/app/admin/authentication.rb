ActiveAdmin.register Authentication do
  menu parent: I18n.t('active_admin.logs')

  actions :index, :show

  controller do
    def scoped_collection
      Authentication.includes(:user, :totem)
    end
  end

  index do
    selectable_column
    column :user_id do |i|
      i.user.rut
    end
    column :auth_type
    column :totem_id do |i|
      i.totem.tid
    end
    column :created_at
    actions
  end

  filter :auth_type,
    as: :select,
    collection: proc { Authentication::AUTH_TYPES }
  filter :user_rut, as: :string
  filter :totem,
    as: :select,
    collection: proc{ Totem.all.pluck(:tid, :id)}
  filter :created_at

  show do
    attributes_table do
      row :auth_type
      row :user_id do |i|
        i.user.rut
      end
      row :minucia
      row :finger
      row :signature
      row :created_at
    end
    active_admin_comments
  end
end

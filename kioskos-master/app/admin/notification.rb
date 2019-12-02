ActiveAdmin.register Notification do

  active_admin_import before_batch_import: lambda { |importer|
                                             chile_atiende_ids = importer.values_at('chile_atiende_id')
                                             repleced_ids = Hash[chile_atiende_ids.map { |v| [v, v.to_i] }]
                                             importer.batch_replace('chile_atiende_id', repleced_ids)
                                           }
  actions :all
  permit_params :rut, :message, :chile_atiende_id

  index do
    selectable_column
    column :rut
    column :message
    column :chile_atiende_id
    column :read
    actions
  end

  filter :rut
  filter :message
  filter :chile_atiende_id
  filter :read
  filter :created_at

  form do |f|
    f.inputs I18n.t('notification.one', scope: 'activerecord.models') do
      f.input :message
      f.input :chile_atiende_id
      f.input :read
    end
    f.actions
  end

  show do
    attributes_table do
      row :rut
      row :read
      row :chile_atiende_id
      row :message
      row :created_at
    end
    active_admin_comments
  end
end

ActiveAdmin.register Institution do
  actions :all
  permit_params :name

  filter :id
  filter :name

  form do |f|
    f.inputs  I18n.t('institution.one', scope: 'activerecord.models') do
      f.input :name
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
    end
  end
end

ActiveAdmin.register Procedure do
  belongs_to :institution, optional: true
  actions :all

  permit_params :name, :price, :active_in_totem, :security,
                :type_of_procedure, :description, :info, :warning,
                :id_proceso_simple, :id_etapa_simple, :class_name_simple,
                :chile_atiende_id, :category, :subcategory, :institution_id

  index do
    selectable_column
    column :id do |procedure|
      link_to procedure.id, admin_procedure_path(procedure)
    end
    column :name do |procedure|
      link_to procedure.name, admin_procedure_path(procedure)
    end
    column :price
    column :active_in_totem
    column :security
    column :type_of_procedure
    column :institution_id
    column :id_proceso_simple
    column :id_etapa_simple
    column :class_name_simple
    column :description
    column :chile_atiende_id
    column :category
    column :subcategory
    actions
  end

  filter :name
  filter :price
  filter :active_in_totem
  filter :security
  filter :type_of_procedure
  filter :class_name_simple
  filter :chile_atiende_id
  filter :institution_id
  filter :category
  filter :subcategory

  form do |f|
    f.inputs  I18n.t('procedure.one', scope: 'activerecord.models') do
      f.input :name
      f.input :price
      f.input :active_in_totem
      f.input :security, collection: Procedure::SECURITY_STATES
      f.input :type_of_procedure, collection: Procedure::TYPES_OF_PROCEDURE
      f.input :info
      f.input :warning
      f.input :id_proceso_simple
      f.input :id_etapa_simple
      f.input :class_name_simple
      f.input :description
      f.input :chile_atiende_id
      f.input :institution_id, as: :select, collection: Institution.allowed_institutions_for(current_admin_user)
      f.input :category
      f.input :subcategory
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :price
      row :active_in_totem
      row :security
      row :type_of_procedure
      row :description
      row :info
      row :warning
      row :id_proceso_simple
      row :id_etapa_simple
      row :class_name_simple
      row :chile_atiende_id
      row :institution_id
      row :category
      row :subcategory
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end

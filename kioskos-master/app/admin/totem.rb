ActiveAdmin.register Totem do
  belongs_to :institution, optional: true
  actions :all
  permit_params :tid, :rut, :active, :location, :location_type, :country_phone_code,
                :institution_id, :has_printer

  index do
    selectable_column
    column :tid do |totem|
      link_to totem.tid, admin_totem_path(totem)
    end
    column :institution_id
    column :active
    column :has_printer
    column :location
    column :location_type do |totem|
      I18n.t(totem.location_type, scope: 'collections.location_type')
    end
    column :ping_time do |totem|
      div class: "#{TotemMonitor.find_by_totem_tid(totem.tid)&.totem_is_down? ? 'totem-down' : ''}" do
        TotemMonitor.find_by_totem_tid(totem.tid)&.ping_time
      end
    end
    actions
  end

  filter :tid
  filter :rut
  filter :active
  filter :location
  filter :location_type
  filter :has_printer

  form do |f|
    f.inputs  I18n.t('totem.one', scope: 'activerecord.models') do
      f.input :tid
      f.input :rut
      f.input :active
      f.input :has_printer
      f.input :location
      f.input :country_phone_code
      f.input :location_type, collection: Totem::LOCATION_TYPES.map{|type| [I18n.t(type, scope: 'collections.location_type'),type]}
      f.input :institution_id, as: :select, collection: Institution.allowed_institutions_for(current_admin_user)
    end
    f.actions
  end

  show do
    attributes_table do
      row :tid
      row :rut
      row :active
      row :has_printer
      row :location
      row :location_type do |totem|
        I18n.t(totem.location_type, scope: 'collections.location_type')
      end
      row :country_phone_code
      row :institution_id
      row :created_at
      row :updated_at
      row :ping_time do |totem|
        div class: "#{TotemMonitor.find_by_totem_tid(totem.tid)&.totem_is_down? ? 'totem-down' : ''}" do
          TotemMonitor.find_by_totem_tid(totem.tid)&.ping_time
        end
      end
    end
    active_admin_comments
  end
end

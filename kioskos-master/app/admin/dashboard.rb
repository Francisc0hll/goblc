ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard.title') }

  content title: proc { I18n.t('active_admin.dashboard.title') } do
    columns do
      column do
        panel I18n.t('active_totem', scope: 'active_admin.dashboard.panel') do
          table_for Totem.actives do
            column :tid
            column :rut
            column :current_sign_in_at
          end
        end
      end

      column do
        panel I18n.t('popular_certificates', scope: 'active_admin.dashboard.panel') do
          table_for Procedure.certificates.highly_requested do
            column :name
            column :request_count
            column :delivery_count
          end
        end
      end
    end
  end
end

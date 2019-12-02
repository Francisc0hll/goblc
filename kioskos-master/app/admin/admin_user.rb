ActiveAdmin.register AdminUser do

  belongs_to :institution, optional: true
  permit_params :email, :password, :password_confirmation, :institution_id, :admin_type

  index do
    selectable_column
    id_column
    column :email do |admin|
      link_to admin.email, admin_admin_user_path(admin)
    end
    column :current_sign_in_at
    column :sign_in_count
    column :institution_id
    column :admin_type do |admin|
      I18n.t(admin.admin_type, scope: 'collections.admin_type')
    end
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs I18n.t('admin_user.one', scope: 'activerecord.models') do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin_type, as: :select, collection: I18n.t('collections.admin_type').to_a.collect(&:reverse)
      f.input :institution_id, as: :select, collection: Institution.allowed_institutions_for(current_admin_user)
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :encrypted_password
      row :reset_password_token
      row :reset_password_sent_at
      row :remember_created_at
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
      row :updated_at
      row :admin_type do |admin|
        I18n.t(admin.admin_type, scope: 'collections.admin_type')
      end
      row :institution
    end
  end

  controller do
    def update
      user_not_super_admin = !current_admin_user.super_admin?
      institutions_are_different = (current_admin_user.institution_id !=
                                    params['admin_user']['institution_id'].to_i)

      if user_not_super_admin && institutions_are_different
        flash.now[:error] = 'No se puede modificar su institución'
        return render 'show'
      end

      if current_admin_user.super_admin? && institutions_are_different
        user_by_email = AdminUser.find_by email: params['admin_user']['email']
        if user_by_email == current_admin_user
          flash.now[:error] = 'No se puede modificar su institución'
          return render 'show'
        end
      end
      if params[:admin_user][:password].blank?
        params[:admin_user].delete("password")
        params[:admin_user].delete("password_confirmation")
      end
      super
    end
  end
end

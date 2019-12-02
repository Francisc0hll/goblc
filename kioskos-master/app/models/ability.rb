class Ability
  include CanCan::Ability

  def initialize(current_admin_user)
    can :read, ActiveAdmin::Page, name: 'Dashboard'

    if current_admin_user.super_admin?
      can :manage, Certificate
      can [:create, :read, :update], AdminUser
      can [:destroy], AdminUser, id: AdminUser.pluck(:id).reject { |id| id == current_admin_user.id } # Can't delete himself
      can [:create, :read, :update], Totem
      can :manage, Notification
      can :manage, Authentication
      can :manage, ClaveUnicaPetition
      can :manage, ProcedureLog
      can :manage, Procedure
      can :manage, SearchProcedureLog
      can [:create, :read, :update], Institution
    elsif current_admin_user.admin?
      can :manage, Certificate, procedure: { institution: current_admin_user.institution }
      can [:read, :update], AdminUser, id: current_admin_user.id
      can [:read, :update], Totem, institution: current_admin_user.institution
      can :manage, Notification
      can :manage, Authentication, totem: { institution: current_admin_user.institution }
      can :manage, ClaveUnicaPetition, totem: { institution: current_admin_user.institution }
      can :manage, ProcedureLog, totem: { institution: current_admin_user.institution }
      can :manage, Procedure, institution: current_admin_user.institution
      can :manage, SearchProcedureLog, totem: { institution: current_admin_user.institution }
      can [:read, :update], Institution, id: current_admin_user.institution.id
    end
  end

end

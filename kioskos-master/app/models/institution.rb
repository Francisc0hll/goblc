class Institution < ApplicationRecord
  has_many :admin_users
  has_many :totems
  has_many :procedures

  allowed_institutions_lambda = lambda do |admin_user|
    return Institution.all if admin_user.super_admin?
    return Institution.where(id: admin_user.institution.id) if admin_user.admin?
    []
  end

  scope :allowed_institutions_for, allowed_institutions_lambda
end

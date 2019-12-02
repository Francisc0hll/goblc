class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :of_institution, ->(institution) { where(institution: institution) }

  belongs_to :institution
  validates :institution_id, presence: true

  ADMIN_TYPES = {
    admin: 'admin',
    super_admin: 'super_admin'
  }.freeze

  def admin?
    admin_type == ADMIN_TYPES[:admin]
  end

  def super_admin?
    admin_type == ADMIN_TYPES[:super_admin]
  end

end

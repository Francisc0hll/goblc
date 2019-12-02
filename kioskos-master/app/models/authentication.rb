class Authentication < ApplicationRecord
  belongs_to :user
  belongs_to :totem

  AUTH_TYPES = ['inicio_sesion', 'clave_unica', 'match_on_card'].freeze

  scope :of_institution, ->(institution) { includes(:totem).where(totems: { institution: institution }) }

  def readonly?
    persisted?
  end
end

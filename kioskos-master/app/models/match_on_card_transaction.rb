class MatchOnCardTransaction < ApplicationRecord
  belongs_to :totem
  scope :of_institution, ->(institution) { includes(:totem).where(totems: { institution: institution }) }
end

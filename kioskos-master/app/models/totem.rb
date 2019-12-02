class Totem < ApplicationRecord
  LOCATION_TYPES = %w(ministerial_office mall train_station subway_station bus_terminal).freeze
  has_many :authentications

  validates :rut, :tid, :country_phone_code, presence: true
  validates :tid, uniqueness: true, if: -> { tid_changed? }
  validates :location_type, inclusion: { in: LOCATION_TYPES }
  belongs_to :institution, optional: true

  scope :by_rut, ->(rut) {
    where(["replace(replace(rut, '-', ''), '.', '') = ?", rut.tr('.-', '')]) if rut.present?
  }
  scope :actives, -> { where(active: true) }
  scope :of_institution, ->(institution) { where(institution: institution) }

  def ministerial?
    location_type == 'ministerial_office'
  end

end

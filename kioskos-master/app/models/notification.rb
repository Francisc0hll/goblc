class Notification < ApplicationRecord
  belongs_to :user, foreign_key: :rut, primary_key: :rut

  validates :rut, :message, presence: true

  scope :unread, -> { where(read: false) }
  scope :with_rut, ->(rut) { where(["replace(replace(rut, '-', ''), '.', '') = ?", rut.tr('.-', '')]) if rut.present? }
  scope :of_institution, ->(_) { Notification.all } # to be implemented later
end

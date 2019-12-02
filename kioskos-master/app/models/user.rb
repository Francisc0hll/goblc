class User < ApplicationRecord
  devise :trackable

  belongs_to :current_totem, class_name: Totem
  belongs_to :last_totem, class_name: Totem
  has_many :notifications, foreign_key: :rut, primary_key: :rut
  has_many :authentications

  before_save :clean_rut

  def assign_totem(totem)
    self.last_totem = current_totem.nil? ? totem : current_totem
    self.current_totem = totem
  end

  def rut_base
    rut[0..-2]
  end

  def rut_dv
    rut.last
  end

  def clean_rut
    self.rut = rut.tr('.-', '')
  end
  def apellidos
    "#{last_name_father} #{last_name_mother}"
  end
end

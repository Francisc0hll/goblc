class ClaveUnicaPetition < ApplicationRecord
  belongs_to :totem

  STATUS = ['requested', 'success', 'failure', 'already_created'].freeze
  METHODS = ['phone', 'screen', 'email'].freeze

  scope :of_institution, ->(institution) { includes(:totem).where(totems: { institution: institution }) }

  def mark_success
    update(status: 'success')
  end

  def mark_failure
    update(status: 'failure')
  end

  def mark_as_already_created
    update(status: 'already_created')
  end

  def already_created?
    status == 'already_created'
  end
end

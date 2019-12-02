class Certificate < ApplicationRecord
  belongs_to :procedure
  scope :of_institution, ->(institution) { includes(:procedure).where(procedures: { institution: institution }) }


  STATUS = %w[requested success failure].freeze

  def mark_success
    update(status: 'success')
  end

  def mark_failure
    update(status: 'failure')
  end
end

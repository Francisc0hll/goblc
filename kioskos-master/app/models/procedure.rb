class Procedure < ApplicationRecord
  ANONYMOUS = 'anonymous'.freeze
  AUTHENTICATION = 'authentication'.freeze
  SECURITY_STATES = [ANONYMOUS, AUTHENTICATION].freeze
  SIMPLE_PROCEDURE = 'simple'.freeze
  COMPLEX_PROCEDURE = 'complex'.freeze
  TYPES_OF_PROCEDURE = [COMPLEX_PROCEDURE, SIMPLE_PROCEDURE].freeze

  belongs_to :institution, optional: true
  scope :certificates, -> { where(type_of_procedure: TYPES_OF_PROCEDURE) }
  scope :actives, -> { where(active_in_totem: true) }
  scope :highly_requested, -> { order('request_count') }
  scope :search_by_name, ->(x) { where('lower(name) LIKE :query', query: "%#{x.downcase}%") if x.present? }
  scope :chile_atiende_ids, -> { pluck(:chile_atiende_id) }
  scope :of_institution, ->(institution) { where(institution: institution)}
  validates :name, presence: true

  def anonymous?
    security == ANONYMOUS
  end

  def simple?
    type_of_procedure == SIMPLE_PROCEDURE
  end

  def complex?
    type_of_procedure == COMPLEX_PROCEDURE
  end

  def require_authentication?
    security == AUTHENTICATION
  end

  def increase_request_count
    self.request_count += 1
    save
  end

  def update_delivery_count
    self.delivery_count += 1
    save
  end

  def self.list_procedures    
    ChileAtiende.search_procedures(6)
  end

  def self.search_procedures(search, next_token)
    ChileAtiende.search_procedures(100, search, next_token)
  end

  def self.get_info(id)
    ChileAtiende.get_procedure(id)
  end
end

class ApiAuthentication < ApplicationRecord

  def is_valid_token?(token_t)
    Time.now <= (created_at.to_datetime + expires_in.seconds) && token_t == token_type
  end
end

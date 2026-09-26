# frozen_string_literal: true

# Authenticates using: Authorization: Bearer <token>
Warden::Strategies.add(:token_authenticatable) do
  def valid?
    bearer_token.present?
  end

  def authenticate!
    user = NewUser.find_by(authentication_token: bearer_token)

    if user&.authentication_token.present?
      success!(user)
    else
      fail!("Invalid authentication token")
    end
  end

  private

  def bearer_token
    header = env["HTTP_AUTHORIZATION"].to_s
    return if header.blank?

    match = header.match(/\ABearer\s+(.+)\z/i)
    match&.captures&.first
  end
end

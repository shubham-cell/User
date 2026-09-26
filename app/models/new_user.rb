class NewUser < ApplicationRecord
  validates :password, presence: true
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  has_one :balance_amount
  has_many :transactions
  has_many :documents
  has_many :reports
  has_one :budget

  before_validation :ensure_authentication_token, on: :create

  def regenerate_authentication_token!
    update!(
      authentication_token: self.class.generate_authentication_token,
      token_last_used_at: Time.current
    )
  end

  def clear_authentication_token!
    update!(authentication_token: nil, token_last_used_at: nil)
  end

  def touch_token_activity!
    update_column(:token_last_used_at, Time.current)
  end

  def token_expired?(timeout = 1.hour)
    return true if token_last_used_at.blank?

    token_last_used_at < timeout.ago
  end

  def self.generate_authentication_token
    loop do
      token = SecureRandom.hex(32)
      break token unless exists?(authentication_token: token)
    end
  end

  private

  def ensure_authentication_token
    self.authentication_token ||= self.class.generate_authentication_token
  end

  def write_query_log
    print "Database query executed for User with id: #{self.id}"
  end
end

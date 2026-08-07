class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "半角英数字とアンダースコアのみ使用できます" }
  validates :name, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end
end

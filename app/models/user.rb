class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :name, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # 投稿・コメント・行ってみたい・行ってみた・通報
  has_many :posts, dependent: :nullify # 退会しても投稿は残す（投稿者情報だけ外れる）
  has_many :comments, dependent: :nullify # 退会してもコメントは残す
  has_many :visits, dependent: :nullify # 退会しても訪問記録は残す
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_posts, through: :bookmarks, source: :post
  has_many :reports, dependent: :destroy
  has_many :residences, dependent: :destroy

  # グループ
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  validates :username, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "半角英数字とアンダースコアのみ使用できます" }
  validates :name, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def current_residence
    residences.current.first
  end

  def move_to!(prefecture:, city:, started_on: Date.current)
    current_residence&.update!(ended_on: started_on - 1.day)
    residences.create!(prefecture: prefecture, city: city, started_on: started_on)
  end
end

class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :user, through: :group_memberships
  has_many :posts, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  def owner
    group_memberships.joins(:user).find_by(role: "owner", users: { status: "active" })&.user
  end
end

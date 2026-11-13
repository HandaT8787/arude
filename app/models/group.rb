class Group < ApplicationRecord
  # グループを削除すると参加の記録（メンバーシップ）も消える
  has_many :group_memberships, dependent: :destroy
  has_many :user, through: :group_memberships

  # グループを削除するとグループ投稿のグループIDが空になり、全体投稿に変わる
  has_many :posts, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  # 退会していないオーナーを返す。退会済みなら管理者が次のオーナーを指定するためnilを返す
  def owner
    group_memberships.joins(:user).find_by(role: "owner", users: { status: "active" })&.user
  end
end

class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :group_id }

  enum :role, { member: "member", owner: "owner" }

end

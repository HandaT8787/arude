class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  enum :role, { member: "member", owner: "owner" } 

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :group_id }
end

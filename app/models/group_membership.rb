class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  ROLES = %w[owner member].freeze

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :group_id }
end

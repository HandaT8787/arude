class Report < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :reason, presence: true
  validates :user_id, uniqueness: { scope: :comment_id }
end

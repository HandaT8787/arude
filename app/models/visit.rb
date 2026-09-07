class Visit < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :post

  has_many :ratings, dependent: :destroy
  has_many_attached :photos

  validates: visited_at, presence: true

  accepts_nested_attributes_for :ratings, reject_if: ->(attrs) { attrs["score"].blank? }
end

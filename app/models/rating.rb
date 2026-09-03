class Rating < ApplicationRecord
  belongs_to :visit

  delegate :user, :post, to: :visit

  RATING_CATEGORY = %w[景色 静かさ 子ども向き 写真映え 滞在しやすさ].freeze

  validates :category, presence: true, inclusion: { in: RATING_CATEGORY }
  validates :score, presence: true, inclusion: { in: 1..5 }
end

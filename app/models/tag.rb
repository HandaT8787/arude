class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :tag_type, presence: true

  # タグカテゴリー設定
  TAG_TYPES = %w[feature time].freeze
  validates :tag_type, inclusion: { in: TAG_TYPES }
end

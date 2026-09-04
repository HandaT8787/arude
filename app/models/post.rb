class Post < ApplicationRecord
  after_validation :reverse_geocode, if: ->(post) { post.latitude.present? && post.longitude.present? }
  after_validation :snapshot_local_years, on: :create

  # ユーザー・グループ
  belongs_to :user, optional: true # 退会後の投稿はuser_idがnullになるため
  belongs_to :group, optional: true

  # コメント・行ってみたい・行ってみた・タグ
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user
  has_many :visits, dependent: :destroy
  has_many :ratings, through: :visits
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # 画像
  has_many_attached :photos

  # 緯度、経度から住所を逆算
  reverse_geocoded_by :latitude, :longitude do |post, results|
    if geo = results.first
      post.prefecture = geo.state
      post.city = geo.city
    end
  end

  validates :title, presence: true
  validates :description, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  # 投稿のタグ数の制限
  validate :tags_count_within_limit

  TIME_TAGS = %w[朝 昼 夕方 夜].freeze

  # 地元歴
  def local_badge
    return nil if local_years_at_post.nil?
    "近所歴#{local_years_at_post}年"
  end

  # 特徴タグ（自由入力）
  def tag_names=(names)
    feature_tags = names.split(",").map(&:strip).reject(&:blank?).map do |name|
      Tag.find_or_create_by(name: name) { |tag| tag.tag_type = "feature" }
    end
    self.tags = feature_tags + time_tag_records
  end

  def tag_names
    tags.where(tag_type: "feature").pluck(:name).join(", ")
  end

  # おすすめ時間帯（チェックボックスで選択、固定タグ一覧から）
  def time_tag_names=(names)
    @time_tag_names = Array(names).reject(&:blank?)
  end

  def time_tag_names
    tags.where(tag_type: "time").pluck(:name)
  end

  private

  def time_tag_records
    Array(@time_tag_names).map do |name|
      Tag.find_or_create_by(name: name) { |tag| tag.tag_type = "time" }
    end
  end

  def snapshot_local_years
    return if user.nil?

    residence = user.residences.find_by(prefecture: prefecture, city: city)
    return if residence.nil?

    self.local_years_at_post = residence.years_at
  end

  def tags_count_within_limit
    if tags.where(tag_type: "feature").size > 10
  end
end

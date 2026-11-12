class Post < ApplicationRecord
  after_validation :reverse_geocode, if: ->(post) { post.latitude.present? && post.longitude.present? }

  # 近所歴は引っ越しによって変更されるため、投稿作成時に投稿時点の近所歴を保存する
  before_create :snapshot_local_years
  before_save :sync_tags

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
    if geo = results.find { |r| r.country_code == "JP" && r.state.present? && r.city.present? }
      post.prefecture = geo.state
      post.city = geo.city
    end
  end

  validates :title, presence: true
  validates :description, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validate :tags_count_within_limit

  # グループ設定・変更時、検証
  # 所属していないグループへの投稿を防ぐ
  # 毎回検証すると退会後の投稿者が編集できなくなるため
  validate :group_membership_required, if: :group_id_changed?

  # 時間帯タグは固定の4種
  TIME_TAGS = %w[朝 昼 夕方 夜].freeze

  # 近所歴
  def local_badge
    return nil if local_years_at_post.nil?
    "近所歴#{Residence.years_to_str(local_years_at_post)}"
  end

  # 特徴タグ（自由入力）
  def tag_names=(names)
    @tag_names = names
  end

  def tag_names
    tags.where(tag_type: "feature").pluck(:name).join(", ")
  end

  # おすすめ時間帯（チェックボックスで選択）
  def time_tag_names=(names)
    @time_tag_names = Array(names).reject(&:blank?)
  end

  def time_tag_names
    tags.where(tag_type: "time").pluck(:name)
  end

  # 指定サイズに縮小した画像を返す
  def thumbnail(width, height)
    return nil unless photos.attached?
    photos.first.variant(resize_to_limit: [ width, height ]).processed
  end

  # グループ投稿のみ投稿者名を表示
  def author_name
    return nil if group.nil?

    if user.present? && user.active?
      user.username
    else
      "退会済みユーザー"
    end
  end

  # 全体投稿と参加中のグループ投稿は表示
  # 管理者は全て表示
  def self.visible_to(user)
    return where(group_id: nil) if user.nil? # 未ログイン
    return all if user.is_admin? # 管理者

    where(group_id: nil).or(where(group_id: user.group_ids))
  end

  # 投稿者は退会後でも自身のグループ投稿が見える
  # 詳細、編集、更新、削除で使用
  # コメント、行ってみたい、行ってみたの作成には使用しない
  def self.own_or_visible_to(user)
    return visible_to(nil) if user.nil?

    visible_to(user).or(where(user_id: user.id))
  end

  # グループ名、コメント、ボタンを表示するか
  # 退会した投稿者へのグループに関する情報の漏えいを防ぐ
  def group_info_visible_to?(user)
    return true if group_id.nil? # 全体投稿
    return false if user.nil? # 未ログイン

    # 管理者もしくは参加中のグループであれば表示
    user.is_admin? || user.group_ids.include?(group_id)
  end

  # 退会したグループ投稿の編集は不可とする
  # 編集画面の投稿先に退会済みのグループが出ず、
  # 保存すると group_id が空になり、全体公開に変わってしまうため
  def editable_by?(user)
    return true if group_id.nil? # 全体投稿
    return false if user.nil? # 未ログイン

    # 参加中のグループであれば編集可能
    user.group_ids.include?(group_id)
  end

  private

  def time_tag_records
    Array(@time_tag_names).map do |name|
      Tag.find_or_create_by(name: name) { |tag| tag.tag_type = "time" }
    end
  end

  # 投稿地点と同じ市区町村に住んでいた期間の合計
  def snapshot_local_years
    return if user.nil?

    residences = user.residences.where(prefecture: prefecture, city: city)
    return if residences.empty?
    days = residences.sum { |r| r.days_at }
    self.local_years_at_post = Residence.days_to_years(days)
  end

  # 投稿のタグは10個までとする
  def tags_count_within_limit
    return if @tag_names.nil?

    names = @tag_names.to_s.split(",").map(&:strip).reject(&:blank?)

    if names.size > 10
      errors.add(:tag_names, "タグは10個以下にしてください")
    end
  end

  # 所属していないグループへの投稿を防ぐ
  def group_membership_required
    return if group_id.blank? || user.nil?
    unless user.group_ids.include?(group_id)
      errors.add(:group_id, "所属していないグループには投稿できません")
    end
  end

  # 編集時にタグ入力がない場合は何もしない
  def sync_tags
    return if @tag_names.nil? && @time_tag_names.nil?

    feature_tags = @tag_names.to_s.split(",").map(&:strip).reject(&:blank?).map do |name|
      Tag.find_or_create_by(name: name) { |tag| tag.tag_type = "feature" }
    end
    self.tags = feature_tags + time_tag_records
  end
end

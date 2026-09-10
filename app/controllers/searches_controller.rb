class SearchesController < ApplicationController
  def index
    # 全投稿取得
    @results = Post.all

    # キーワード検索絞り込み
    @results = @results.where("title LIKE :keyword OR description LIKE :keyword", keyword: "%#{params[:keyword]}%") if params[:keyword].present?

    # カテゴリー検索絞り込み
    @results = @results.where(category: params[:category]) if params[:category].present?

    # タグ検索絞り込み
    @results = @results.joins(:tags).where(tags: { name: params[:tag_name] }) if params[:tag_name].present?

    @results = @results.order(created_at: :desc).page(params[:page]).per(12)
  end
end

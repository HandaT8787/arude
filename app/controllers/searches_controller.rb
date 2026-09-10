class SearchesController < ApplicationController
  def index
    @results = Post.all
    @results = @results.where("title LIKE :keyword OR description LIKE :keyword", keyword: "%#{params[:keyword]}%") if params[:keyword].present?
    @results = @results.where(category: params[:category]) if params[:category].present?
    @results = @results.joins(:tags).where(tags: { name: params[:tag_name] }) if params[:tag_name].present?
    @results = @results.order(created_at: :desc).page(params[:page]).per(12)
  end
end

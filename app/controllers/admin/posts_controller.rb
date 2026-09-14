class Admin::PostsController < ApplicationController
  include AdminAuthorization

  before_action :set_post, only: %i[destroy]

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "投稿を削除しました"
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end
end

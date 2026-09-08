class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  before_action :set_post, only: %i[show edit update destroy]
  before_action :require_owner!, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page]).per(12)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "投稿しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "投稿を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def require_owner!
    redirect_to post_path(@post), alert: "この操作は投稿者のみ行えます" unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(
      :title, :description, :category, :congestion, :price, :caution,
      :latitude, :longitude, :group_id, :tag_names, photos: [], time_tag_names: []
    )
  end
end

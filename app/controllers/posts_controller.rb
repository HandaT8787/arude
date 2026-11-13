class PostsController < ApplicationController
  # 後ろのチェックで @post を使用するため、 set_postから実行する
  before_action :set_post, only: %i[show edit update destroy]

  # 本人の投稿のみを編集、更新、削除できる
  before_action :require_owner!, only: %i[edit update destroy]

  # 退会済みのグループ投稿は本人でも編集できない
  # グループIDが更新されて、意図せず全体公開になってしまうため
  before_action :require_editable!, only: %i[edit update]

  # ゲストユーザーは投稿できない
  before_action :require_user!, only: %i[create]

  # 全体投稿と参加しているグループ投稿を表示
  # 退会済みのグループ投稿は表示しない
  # own_or_visible_to を使うと、退会した本人にだけ旧グループ投稿が一覧に出るため、使わない
  def index
    @posts = Post.visible_to(current_user).includes(:user).order(created_at: :desc).page(params[:page]).per(12)
  end

  def show
  end

  def new
    @post = Post.new
    @my_groups = current_user.groups
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "投稿しました"
    else
      @my_groups = current_user.groups
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @my_groups = current_user.groups
  end

  def update
    post_attrs = post_params
    if post_attrs[:photos].reject(&:blank?).empty?
      post_attrs.delete(:photos)
    end
    if @post.update(post_attrs)
      redirect_to @post, notice: "投稿を更新しました"
    else
      @my_groups = current_user.groups
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private

  # 全体投稿、参加中のグループ投稿、本人の投稿（退会済みのグループ投稿を含む）が対象
  # 退会した本人が自分の退会済みグループ投稿を開く・削除するため
  # 編集は require_editable! で止める
  def set_post
    @post = Post.own_or_visible_to(current_user).find(params[:id])
  end

  def require_owner!
    redirect_to post_path(@post), alert: "この操作は投稿者のみ行えます" unless @post.user == current_user
  end

  def require_user!
    redirect_to posts_path, alert: "この操作はゲストユーザーではできません" if current_user.is_guest?
  end

  def require_editable!
    redirect_to post_path(@post), alert: "退会したグループの投稿は編集できません" unless @post.editable_by?(current_user)
  end

  def post_params
    params.require(:post).permit(
      :title, :description, :category, :congestion, :price, :caution,
      :latitude, :longitude, :group_id, :tag_names, photos: [], time_tag_names: []
    )
  end
end

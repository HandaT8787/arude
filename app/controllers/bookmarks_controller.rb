class BookmarksController < ApplicationController
  before_action :set_post
  before_action :require_user!, only: %i[create]

  def create
    @bookmark = @post.bookmarks.build(user: current_user)
    if @bookmark.save
      redirect_to @post, notice: "行きたいに保存しました"
    else
      redirect_to @post, alert: "追加できませんでした"
    end
  end

  def destroy
    bookmark = @post.bookmarks.find(params[:id])
    if bookmark.user == current_user
      bookmark.destroy
      redirect_to @post, notice: "行きたいを削除しました"
    else
      redirect_to @post, alert: "この操作はできません"
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def require_user!
    redirect_to @post, alert: "この操作はゲストユーザーではできません" if current_user.is_guest?
  end
end

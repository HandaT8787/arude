class CommentsController < ApplicationController
  before_action :set_post
  before_action :require_comment_owner!, only: %i[destroy]
  before_action :require_user!, only: %i[create]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: "コメントを投稿しました"
    else
      redirect_to @post, alert: "コメントの投稿に失敗しました"
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: "コメントを削除しました"
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def require_comment_owner!
    @comment = @post.comments.find(params[:id])
    redirect_to @post, alert: "この操作はコメント投稿者のみ行えます" unless @comment.user == current_user || current_user.is_admin?
  end

  def require_user!
    redirect_to @post, alert: "この操作はゲストユーザーではできません" if current_user.is_guest?
  end
end

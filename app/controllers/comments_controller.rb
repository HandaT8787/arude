class CommentsController < ApplicationController
  before_action :set_post

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
    comment = @post.comments.find(params[:id])
    if comment.user == current_user
      comment.destroy
      redirect_to @post, notice: "コメントを削除しました"
    else
      redirect_to @post, alert: "この操作はコメント投稿者のみ行えます"
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

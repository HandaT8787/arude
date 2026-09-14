class Admin::CommentsController < ApplicationController
  include AdminAuthorization

  before_action :set_comment, only: %i[destroy]

  def index
    @comments = Comment.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def destroy
    @comment.destroy
    redirect_to admin_comments_path, notice: "コメントを削除しました"
  end

  private
  def set_comment
    @comment = Comment.find(params[:id])
  end
end

class Admin::UsersController < ApplicationController
  include AdminAuthorization

  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザーを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :username, :status)
  end
end

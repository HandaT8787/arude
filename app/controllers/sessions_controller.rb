class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create guest ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "しばらくしてから再試行してください" }

  def new
  end

  def create
    if user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
      start_new_session_for user
      redirect_to home_path, notice: "ログインしました"
    else
      redirect_to new_session_path, alert: " メールアドレスまたはパスワードが違います"
    end
  end

  def guest
    user = User.guest
    start_new_session_for user
    redirect_to home_path, notice: "ゲストログインしました"
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end

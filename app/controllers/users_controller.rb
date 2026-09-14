class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to home_path, notice: "登録が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def mypage
    @posts_count = current_user.posts.count
    @bookmarked_posts_count = current_user.bookmarked_posts.count
    @visits_count = current_user.visits.count
    @past_residences = current_user.residences.past.order(started_on: :desc)
  end

  def posts
    @posts = current_user.posts.order(created_at: :desc).page(params[:page]).per(12)
  end

  def bookmarks
    @bookmarked_posts = current_user.bookmarked_posts.order(created_at: :desc).page(params[:page]).per(12)
  end

  def visits
    @visits = current_user.visits.order(visited_at: :desc).page(params[:page]).per(12)
  end

  def show
    @target_user = User.find(params[:id])
    if @target_user == current_user
      redirect_to mypage_path
    else
      @shared_groups = current_user.groups & @target_user.groups
      if @shared_groups.any?
        @shared_posts = @target_user.posts.where(group: @shared_groups)
      end
    end
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(profile_params)
      update_residence_if_changed
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    terminate_sessison
    redirect_to root_path, notice: "退会が完了しました"
  end

  private
  def user_params
    params.require(:user).permit(:email_address, :name, :username, :password, :password_confirmation)
  end

  def profile_params
    params.require(:user).permit(:name, :username, :bio)
  end

  def update_residence_if_changed
    prefecture = params[:user][:prefecture]
    city = params[:user][:city]
    return if prefecture.blank? || city.blank?

    current = current_user.current_residence
    return if current&.prefecture == prefecture && current&.city == city

    current_user.move_to!(prefecture: prefecture, city: city)
  end
end
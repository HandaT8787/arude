class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]
  before_action :require_group_owner!, only: %i[edit update destroy]

  def index
    @groups = Group.all.page(params[:page]).per(15)
  end

  def show
    @my_membership = @group.group_memberships.find_by(user: current_user)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      @group.group_memberships.create!(user: current_user, role:"owner")
      redirect_to group_path(@group), notice: "グループを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "グループを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: "グループを削除しました"
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def require_group_owner!
    redirect_to @group, alert: "この操作はグループオーナーのみ行えます" unless @group.owner == current_user || current_user.is_admin?
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end

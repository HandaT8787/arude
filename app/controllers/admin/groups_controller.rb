class Admin::GroupsController < ApplicationController
  include AdminAuthorization

  before_action :set_group, only: %i[show edit update destroy]
  
  def index
    @groups = Group.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @members = @group.group_memberships
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to admin_groups_path, notice: "グループを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group.destroy
    redirect_to admin_groups_path, notice: "グループを削除しました"
  end

  private
  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description)
  end
end

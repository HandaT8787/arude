class GroupMembershipsController < ApplicationController
  before_action :set_group
  before_action :require_group_membership_owner!, only: %i[destroy]
  before_action :require_group_owner!, only: %i[update]

  def create
    @group_membership = @group.group_memberships.build
    @group_membership.user = current_user
    @group_membership.role = "member"

    if @group_membership.save
      redirect_to @group, notice: "グループに参加しました"
    else
      redirect_to @group, alert: "グループの参加に失敗しました"
    end
  end

  def destroy
    @group_membership.destroy
    redirect_to @group, notice: "グループを退会しました"
  end

  def update
    new_owner_membership = @group.group_memberships.find(params[:id])
    current_owner_membership = @group.group_memberships.find_by(role: "owner")

    new_owner_membership.role = "owner"
    current_owner_membership.role = "member"

    if new_owner_membership.save && current_owner_membership.save
      redirect_to @group, notice: "オーナーを譲渡しました"
    else
      redirect_to @group, alert: "オーナー譲渡に失敗しました"
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def require_group_owner!
    redirect_to @group, alert: "この操作はグループオーナーのみ行えます" unless @group.owner == current_user || current_user.is_admin?
  end

  def require_group_membership_owner!
    @group_membership = @group.group_memberships.find(params[:id])
    redirect_to @group, alert: "この操作は本人のみ行えます" unless @group_membership.user == current_user || current_user.is_admin?
  end
end
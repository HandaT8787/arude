class Admin::GroupMembershipsController < ApplicationController
  include AdminAuthorization

  def update
    @group_membership = Group.find(params[:group_id]).group_memberships.find(params[:id])
    old_owner_membership = @group.group_memberships.joins(:user).find_by(role: "owner", users: { status: "withdrawn" })
    old_owner_membership&.update(role: "member")

    if @group_membership.update(role: "owner")
      redirect_to admin_groups_path, notice: "オーナーを指名しました"
    else
      redirect_to admin_groups_path, alert: "オーナー指名に失敗しました"
    end
  end
end

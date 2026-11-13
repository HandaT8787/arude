class Admin::GroupMembershipsController < ApplicationController
  include AdminAuthorization

  # オーナー退会時操作
  # オーナーが退会した場合、管理者がオーナーを指名する
  def update
    @group = Group.find(params[:group_id])
    @group_membership = @group.group_memberships.find(params[:id])

    unless @group.owner.nil?
      redirect_to admin_groups_path, alert: "オーナーが退会していないので指名できません"
      return
    end

    unless @group_membership.user.active?
      redirect_to admin_groups_path, alert: "退会済みのユーザーはオーナーに指名できません"
      return
    end

    old_owner_membership = @group.group_memberships.joins(:user).find_by(role: "owner", users: { status: "withdrawn" })

    ActiveRecord::Base.transaction do
      old_owner_membership&.update!(role: "member")
      @group_membership.update!(role: "owner")
    end
    redirect_to admin_groups_path, notice: "オーナーを指名しました"
  rescue ActiveRecord::RecordInvalid
    redirect_to admin_groups_path, alert: "オーナー指名に失敗しました"
  end
end

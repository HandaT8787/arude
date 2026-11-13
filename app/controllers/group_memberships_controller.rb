class GroupMembershipsController < ApplicationController
  # あとのチェックがグループを使用するため最初に実行
  before_action :set_group

  # グループ参加中の本人もしくは管理者であることを確認
  before_action :require_group_membership_owner!, only: %i[destroy]

  # グループのオーナーもしくは管理者であることを確認
  before_action :require_group_owner!, only: %i[update]

  # ゲストユーザーはグループに参加できない
  before_action :require_user!, only: %i[create]

  # グループ参加
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

  # グループ退会
  def destroy
    @group_membership.destroy
    redirect_to @group, notice: "グループを退会しました"
  end

  # グループオーナー譲渡
  # 新しいオーナーを owner、今のオーナーを member に入れ替える
  def update
    new_owner_membership = @group.group_memberships.find(params[:id])
    current_owner_membership = @group.group_memberships.find_by(role: "owner")

    # 自分自身に譲渡するとオーナーが不在になるため
    if new_owner_membership == current_owner_membership
      redirect_to @group, alert: "自分に譲渡することはできません"
      return
    end

    new_owner_membership.role = "owner"
    current_owner_membership&.role = "member"

    ActiveRecord::Base.transaction do
      new_owner_membership.save!
      current_owner_membership&.save!
    end
    redirect_to @group, notice: "オーナーを譲渡しました"
  rescue ActiveRecord::RecordInvalid
    redirect_to @group, alert: "オーナー譲渡に失敗しました"
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def require_group_owner!
    redirect_to @group, alert: "この操作はグループオーナーのみ行えます" unless @group.owner == current_user || current_user.is_admin?
  end

  # 退会する本人（または管理者）を通す
  # あとの destroy で使う @group_membership もセットする
  def require_group_membership_owner!
    @group_membership = @group.group_memberships.find(params[:id])
    redirect_to @group, alert: "この操作は本人のみ行えます" unless @group_membership.user == current_user || current_user.is_admin?
  end

  def require_user!
    redirect_to @group, alert: "この操作はゲストユーザーではできません" if current_user.is_guest?
  end
end

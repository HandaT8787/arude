require 'rails_helper'

RSpec.describe "GroupMemberships", type: :request do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let!(:owner) { create(:user) }
  let!(:owner_membership) { create(:group_membership, :owner, user: owner, group: group) }

  describe "POST /groups/:group_id/group_memberships" do
    context "ログイン中の一般ユーザーの時" do
      before { sign_in(user) }

      it "グループに参加できる" do
        expect { post group_group_memberships_path(group) }.to change(GroupMembership, :count).by(1)
        expect(response).to redirect_to(group_path(group))
      end

      it "roleはmemberになる" do
        post group_group_memberships_path(group)
        expect(GroupMembership.find_by(user: user, group: group).role).to eq("member")
      end
    end

    context "参加中の一般ユーザーの時" do
      let!(:group_membership) { create(:group_membership, user: user, group: group) }
      before { sign_in(user) }

      it "参加できない" do
        expect { post group_group_memberships_path(group) }.not_to change(GroupMembership, :count)
        expect(response).to redirect_to(group_path(group))
      end
    end

    context "ゲストユーザーの時" do
      let(:guest_user) { create(:user, :guest) }
      before { sign_in(guest_user) }

      it "参加できない" do
        expect { post group_group_memberships_path(group) }.not_to change(GroupMembership, :count)
      end
    end

    context "未ログインの時" do
      it "ログインを求められる（リダイレクトされる）" do
        post group_group_memberships_path(group)
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "DELETE /groups/:group_id/group_memberships/:id" do
    let!(:membership) { create(:group_membership, user: user, group: group) }

    context "本人の時" do
      before { sign_in(user) }

      it "退会できる" do
        expect { delete group_group_membership_path(group, membership) }.to change(GroupMembership, :count).by(-1)
        expect(response).to redirect_to(group_path(group))
      end
    end

    context "他のユーザーの時" do
      let!(:other_user) { create(:user) }
      before { sign_in(other_user) }

      it "退会させられない" do
        expect { delete group_group_membership_path(group, membership) }.not_to change(GroupMembership, :count)
        expect(response).to redirect_to(group_path(group))
      end
    end

    context "管理者の時" do
      let!(:admin) { create(:user, :admin) }
      before { sign_in(admin) }

      it "他人を退会させられる" do
        expect { delete group_group_membership_path(group, membership) }.to change(GroupMembership, :count).by(-1)
        expect(response).to redirect_to(group_path(group))
      end
    end
  end

  describe "PATCH /groups/:group_id/group_memberships/:id" do
    let!(:new_owner) { create(:user) }
    let!(:new_owner_membership) { create(:group_membership, user: new_owner, group: group) }

    context "現オーナーの時" do
      before { sign_in(owner) }

      it "オーナーを譲渡できる" do
        patch group_group_membership_path(group, new_owner_membership)
        expect(response).to redirect_to(group_path(group))
        expect(new_owner_membership.reload.role).to eq("owner")
        expect(owner_membership.reload.role).to eq("member")
      end
    end

    context "オーナーでないメンバーの時" do
      before { sign_in(new_owner) }

      it "譲渡できない" do
        patch group_group_membership_path(group, new_owner_membership)
        expect(response).to redirect_to(group_path(group))
        expect(new_owner_membership.reload.role).to eq("member")
        expect(owner_membership.reload.role).to eq("owner")
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Admin::GroupMemberships", type: :request do
  describe "PATCH /admin/groups/:group_id/group_memberships/:id" do
    let(:admin) { create(:user, :admin) }
    let(:general_user) { create(:user) }
    let!(:group) { create(:group) }
    let!(:old_owner) { create(:user, :withdrawn) }
    let!(:new_member) { create(:user) }
    let!(:old_owner_membership) { create(:group_membership, :owner, user: old_owner, group: group) }
    let!(:new_membership) { create(:group_membership, user: new_member, group: group) }

    context "管理者の時" do
      before { sign_in(admin) }

      it "新しいオーナーを指名できる" do
        patch admin_group_group_membership_path(group, new_membership)
        expect(response).to redirect_to(admin_groups_path)
        expect(new_membership.reload.role).to eq("owner")
      end

      it "退会済みの元オーナーはmemberに戻る" do
        patch admin_group_group_membership_path(group, new_membership)
        expect(old_owner_membership.reload.role).to eq("member")
      end

      it "退会済みのメンバーは指名できない" do
        withdrawn_user = create(:user, :withdrawn)
        withdrawn_membership = create(:group_membership, user: withdrawn_user, group: group)
        patch admin_group_group_membership_path(group, withdrawn_membership)
        expect(withdrawn_membership.reload.role).to eq("member")
        expect(old_owner_membership.reload.role).to eq("owner")
      end

      context "今のオーナーが退会していないとき" do
        let!(:other_group) { create(:group) }
        let!(:other_owner_membership) { create(:group_membership, :owner, user: create(:user), group: other_group) }
        let!(:other_member_membership) { create(:group_membership, user: create(:user), group: other_group) }

        it "指名できない" do
          patch admin_group_group_membership_path(other_group, other_member_membership)
          expect(response).to redirect_to(admin_groups_path)
          expect(other_member_membership.reload.role).to eq("member")
          expect(other_owner_membership.reload.role).to eq("owner")
        end
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "指名できず、root_pathに飛ぶ" do
        patch admin_group_group_membership_path(group, new_membership)
        expect(response).to redirect_to(root_path)
        expect(new_membership.reload.role).to eq("member")
      end
    end
  end
end

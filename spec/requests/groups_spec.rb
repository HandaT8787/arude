require 'rails_helper'

RSpec.describe "Groups", type: :request do
  include_context "グループ投稿のデータ"

  describe "GET /groups/:group_id" do
    it "メンバーならグループにグループ投稿が表示される" do
      sign_in(member)
      get group_path(group)
      expect(response.body).to include("group_only")
    end

    it "メンバー以外ならグループにグループ投稿が表示されない" do
      sign_in(outsider)
      get group_path(group)
      expect(response.body).not_to include("group_only")
      expect(response.body).to include("グループに参加すると投稿が表示されます")
    end
  end

  describe "退会ボタン" do
    context "member の時" do
      it "退会するボタンが出る" do
        other_group = create(:group)
        create(:group_membership, :owner, user: create(:user), group: other_group)
        create(:group_membership, user: member, group: other_group)
        sign_in(member)
        get group_path(other_group)
        expect(response.body).to include("退会する")
        expect(response.body).not_to include("オーナーを譲渡してから")
      end
    end

    context "他にメンバーがいるオーナーの時" do
      it "退会するボタンが出ず、譲渡の案内が出る" do
      end
    end

    context "唯一のメンバーのオーナーの時" do
      it "確認付きの退会するボタンが出る" do
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "Admin::Groups", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }
  let!(:target_group) { create(:group, name: "target") }

  describe "GET /admin/groups" do
    context "未ログインの時" do
      it "ログインを求められる（リダイレクトされる）" do
        get admin_groups_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "トップページにリダイレクトされる" do
        get admin_groups_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "管理者の時" do
      before { sign_in(admin) }

      it "一覧を開ける" do
        get admin_groups_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /admin/groups/:id" do
    context "未ログインの時" do
      it "ログインを求められる（リダイレクトされる）" do
        get admin_group_path(target_group)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "トップページにリダイレクトされる" do
        get admin_group_path(target_group)
        expect(response).to redirect_to(root_path)
      end
    end

    context "管理者の時" do
      before { sign_in(admin) }

      it "詳細を開ける" do
        get admin_group_path(target_group)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /admin/groups/:id" do
    context "管理者の時" do
      before { sign_in(admin) }

      it "名前を変更できる" do
        patch admin_group_path(target_group), params: { group: { name: "new" } }
        expect(response).to redirect_to(admin_groups_path)
        expect(target_group.reload.name).to eq("new")
      end

      it "名前が空だと更新できない" do
        patch admin_group_path(target_group), params: { group: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "名前を変更できない" do
        patch admin_group_path(target_group), params: { group: { name: "new" } }
        expect(response).to redirect_to(root_path)
        expect(target_group.reload.name).to eq("target")
      end
    end
  end

  describe "DELETE /admin/groups/:id" do
    context "管理者の時" do
      before { sign_in(admin) }

      it "グループを削除できる" do
        expect { delete admin_group_path(target_group) }.to change(Group, :count).by(-1)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "グループを削除できない" do
        expect { delete admin_group_path(target_group) }.not_to change(Group, :count)
      end
    end
  end
end

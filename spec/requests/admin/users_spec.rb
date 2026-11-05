require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }

  describe "GET /admin/users" do
    context "未ログインの時" do
      it "ログインを求められる（リダイレクトされる）" do
        get admin_users_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "トップページにリダイレクトされる" do
        get admin_users_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "管理者の時" do
      before { sign_in(admin) }

      it "一覧を開ける" do
        get admin_users_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /admin/users/:id" do
    context "未ログインの時" do
      it "ログインを求められる（リダイレクトされる）" do
        get admin_user_path(general_user)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "トップページにリダイレクトされる" do
        get admin_user_path(general_user)
        expect(response).to redirect_to(root_path)
      end
    end

    context "管理者の時" do
      before { sign_in(admin) }

      it "詳細を開ける" do
        get admin_user_path(general_user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /admin/users/:id" do
    let(:target_user) { create(:user) }
    
    context "管理者の時" do
      before { sign_in(admin) }

      it "statusを更新できる" do
        patch admin_user_path(target_user), params: { user: { status: "withdrawn" } }
        expect(response).to redirect_to(admin_user_path(target_user))
        expect(target_user.reload.status).to eq("withdrawn")
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "statusを更新できない" do
        patch admin_user_path(target_user), params: { user: { status: "withdrawn" } }
        expect(response).to redirect_to(root_path)
        expect(target_user.reload.status).to eq("active")
      end
    end
  end
end

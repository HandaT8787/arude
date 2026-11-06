require 'rails_helper'

RSpec.describe "Admin::Posts", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }

  describe "GET /admin/posts" do
    context "未ログインの時" do
      it "ログインを求められる（リダイレクトされる）" do
        get admin_posts_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "トップページにリダイレクトされる" do
        get admin_posts_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "管理者の時" do
      before { sign_in(admin) }

      it "一覧を開ける" do
        get admin_posts_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /admin/posts/:id" do
    let!(:target_post) { create(:post) }

    context "管理者の時" do
      before { sign_in(admin) }

      it "投稿が削除される" do
        expect { delete admin_post_path(target_post) }.to change(Post, :count).by(-1)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "投稿は削除されない" do
        expect { delete admin_post_path(target_post) }.not_to change(Post, :count)
      end
    end
  end
end

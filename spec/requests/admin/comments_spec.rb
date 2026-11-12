require 'rails_helper'

RSpec.describe "Admin::Comments", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }

  describe "GET /admin/comments" do
    context "未ログインの時" do
      it "ログインを求められる（リダイレクトされる）" do
        get admin_comments_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "トップページにリダイレクトされる" do
        get admin_comments_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "管理者の時" do
      before { sign_in(admin) }

      it "一覧を開ける" do
        get admin_comments_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /admin/comments/:id" do
    let!(:comment) { create(:comment) }

    context "管理者の時" do
      before { sign_in(admin) }

      it "コメントが削除される" do
        expect { delete admin_comment_path(comment) }.to change(Comment, :count).by(-1)
      end
    end

    context "一般ユーザーの時" do
      before { sign_in(general_user) }

      it "コメントは削除されない" do
        expect { delete admin_comment_path(comment) }.not_to change(Comment, :count)
      end
    end
  end
end

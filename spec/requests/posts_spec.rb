require 'rails_helper'

RSpec.describe "Posts", type: :request do
  include_context "グループ投稿のデータ"

  let(:leaver) { create(:user) }

  describe "GET /posts/:id" do
    it "メンバーはグループ投稿が表示される" do
      sign_in(member)
      get post_path(group_post)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(group_path(group))
      expect(response.body).to include("みんなのひとこと")
    end

    it "メンバー以外はグループ投稿を見られない" do
      sign_in(outsider)
      get post_path(group_post)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /posts" do
    it "メンバーにはグループ投稿が一覧に出る" do
      sign_in(member)
      get posts_path
      expect(response.body).to include("group_only")
    end

    it "メンバー以外には出ない" do
      sign_in(outsider)
      get posts_path
      expect(response.body).to include("public_post")
      expect(response.body).not_to include("group_only")
    end
  end

  context "グループを退会した本人" do
    let!(:leaver_post) do
      membership = create(:group_membership, user: leaver, group: group)
      target = create(:post, user: leaver, group: group, title: "退会者の旧グループ投稿")
      membership.destroy
      target
    end

    before do
      leaver.reload
      sign_in(leaver)
    end

    describe "GET /posts/:id" do
      it "退会した本人が自分の旧グループ投稿を開く" do
        get post_path(leaver_post)
        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include(group_path(group))
        expect(response.body).not_to include("みんなのひとこと")
      end

      it "他人のグループ投稿を開く" do
        get post_path(group_post)
        expect(response).to have_http_status(:not_found)
      end

      it "退会した本人が旧グループ投稿の編集を開く" do
        get edit_post_path(leaver_post)
        expect(response).to redirect_to(post_path(leaver_post))
      end
    end

    describe "GET posts" do
      it "退会した本人の一覧に旧グループ投稿が出ない" do
        get posts_path
        expect(response.body).not_to include("退会者の旧グループ投稿")
      end
    end

    describe "PATCH /posts/:id" do
      it "退会した本人が旧グループ投稿を更新する" do
        patch post_path(leaver_post), params: { post: { title: "変更" } }
        expect(response).to redirect_to(post_path(leaver_post))
        expect(leaver_post.reload.group_id).to eq(group.id)
        expect(leaver_post.title).not_to eq("変更")
      end
    end

    describe "DELETE /posts/:id" do
      it "退会した本人が旧グループ投稿を削除する" do
        expect { delete post_path(leaver_post) }.to change(Post, :count).by(-1)
      end
    end
  end
end

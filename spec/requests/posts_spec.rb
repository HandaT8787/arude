require 'rails_helper'

RSpec.describe "Posts", type: :request do
  include_context "グループ投稿のデータ"
  
  describe "GET /posts/:id" do
    it "メンバーはグループ投稿が表示される" do
      sign_in(member)
      get post_path(group_post)
      expect(response).to have_http_status(:ok)
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
end

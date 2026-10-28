require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  include_context "グループ投稿のデータ"

  describe "POST /posts/:post_id/bookmarks" do
    it "メンバーであればグループ投稿にブックマークが出来る" do
      sign_in(member)
      post post_bookmarks_path(group_post)
      expect(group_post.bookmarks.count).to eq(1)
    end

    it "メンバー以外ならブックマーク出来ない" do
      sign_in(outsider)
      post post_bookmarks_path(group_post)
      expect(response).to have_http_status(:not_found)
      expect(group_post.bookmarks.count).to eq(0)
    end
  end
end

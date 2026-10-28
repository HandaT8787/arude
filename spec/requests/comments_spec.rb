require 'rails_helper'

RSpec.describe "Comments", type: :request do
  include_context "グループ投稿のデータ"

  describe "POST /posts/:post_id/comments" do
    it "メンバーであればグループ投稿にコメントが出来る" do
      sign_in(member)
      post post_comments_path(group_post), params: { comment: { body: "comment_test" } }
      expect(group_post.comments.count).to eq(1)
    end

    it "メンバー以外ならコメント出来ない" do
      sign_in(outsider)
      post post_comments_path(group_post), params: { comment: { body: "comment_test" } }
      expect(response).to have_http_status(:not_found)
      expect(group_post.comments.count).to eq(0)
    end
  end
end

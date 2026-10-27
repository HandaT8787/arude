require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts/:id" do
    let(:group) { create(:group) }
    let(:member) { create(:user) }
    let(:outsider) { create(:user) }
    let(:author) { create(:user) }
    let!(:group_post) { create(:post, group: group, user: author) }

    before do
      create(:group_membership, user: member, group: group)
    end

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
end

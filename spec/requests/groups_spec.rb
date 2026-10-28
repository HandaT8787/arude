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
end

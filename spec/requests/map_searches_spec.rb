require 'rails_helper'

RSpec.describe "MapSearches", type: :request do
  include_context "グループ投稿のデータ"

  describe "GET /index" do
    it "メンバーにはグループ投稿が検索結果に出る" do
      sign_in(member)
      get map_searches_path, params: { lat: 35.18, lng: 136.9 }
      expect(response.body).to include("group_only")
    end

    it "メンバー以外にはグループ投稿が出ない" do
      sign_in(outsider)
      get map_searches_path, params: { lat: 35.18, lng: 136.9 }
      expect(response.body).not_to include("group_only")
      expect(response.body).to include("public_post")
    end
  end
end

require 'rails_helper'

RSpec.describe "Searches", type: :request do
  include_context "グループ投稿のデータ"

  describe "GET /searches" do
    it "メンバーにはグループ投稿が検索結果に出る" do
      sign_in(member)
      get searches_path
      expect(response.body).to include("group_only")
    end

    it "メンバー以外にはグループ投稿が出ない" do
      sign_in(outsider)
      get searches_path
      expect(response.body).not_to include("group_only")
      expect(response.body).to include("public_post")
    end

    it "キーワード検索でもメンバー以外にはグループ投稿が出ない" do
      sign_in(outsider)
      get searches_path, params: { keyword: "secret_keyword" }
      expect(response.body).not_to include("group_only")
    end

    it "キーワード検索でメンバーにはグループ投稿が出る" do
      sign_in(member)
      get searches_path, params: { keyword: "secret_keyword" }
      expect(response.body).to include("group_only")
    end
  end
end

require 'rails_helper'

RSpec.describe "Homes", type: :request do
  include_context "グループ投稿のデータ"

  describe "GET /home" do
    it "メンバーにはグループ投稿が今日のアルデーに出る" do
      sign_in(member)
      get home_path
      expect(response.body).to include("group_only")
    end

    it "メンバー以外にはグループ投稿が今日のアルデーに出ない" do
      sign_in(outsider)
      get home_path
      expect(response.body).not_to include("group_only")
      expect(response.body).to include("public_post")
    end

    it "居住地のあるメンバーでグループ投稿が今日のアルデーに出る" do
      create(:residence, user: member)
      sign_in(member)
      get home_path
      expect(response.body).to include("group_only")
    end

    it "居住地のあるメンバー以外でグループ投稿が今日のアルデーに出ない" do
      create(:residence, user: outsider)
      sign_in(outsider)
      get home_path
      expect(response.body).not_to include("group_only")
      expect(response.body).to include("public_post")
    end
  end
end

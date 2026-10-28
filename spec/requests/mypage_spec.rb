require 'rails_helper'

RSpec.describe "Mypage", type: :request do
  include_context "グループ投稿のデータ"

  describe "GET /mypage/bookmarks" do
    before do
      create(:bookmark, user: member, post: group_post)
    end

    it "メンバーならブックマーク一覧に出る" do
      sign_in(member)
      get mypage_bookmarks_path
      expect(response.body).to include("group_only")
    end

    it "グループを抜けたらブックマーク一覧に出ない" do
      sign_in(member)
      GroupMembership.find_by(user: member, group: group).destroy
      get mypage_bookmarks_path
      expect(response.body).not_to include("group_only")
    end
  end

  describe "GET /mypage/visits" do
    before do
      create(:visit, user: member, post: group_post)
    end

    it "メンバーなら行ってみた一覧に出る" do
      sign_in(member)
      get mypage_visits_path
      expect(response.body).to include("group_only")
    end

    it "グループを抜けたら行ってみた一覧に出ない" do
      sign_in(member)
      GroupMembership.find_by(user: member, group: group).destroy
      get mypage_visits_path
      expect(response.body).not_to include("group_only")
    end
  end
end

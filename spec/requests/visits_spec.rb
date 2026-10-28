require 'rails_helper'

RSpec.describe "Visits", type: :request do
  include_context "グループ投稿のデータ"

  describe "GET /posts/:post_id/visits" do
    it "メンバーであればグループ投稿に行ってみたが出来る" do
      sign_in(member)
      get post_visits_path(group_post)
      expect(response).to have_http_status(:ok)
    end

    it "メンバー以外なら行ってみた出来ない" do
      sign_in(outsider)
      get post_visits_path(group_post)
      expect(response).to have_http_status(:not_found)
    end
  end
end

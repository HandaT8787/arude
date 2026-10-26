require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "#local_badge" do
    it "近所歴が空欄ならバッチは表示されない" do
      post = build(:post, local_years_at_post: nil)
      expect(post.local_badge).to be_nil
    end

    it "近所歴が1年未満なら1年未満と表示" do
      post = build(:post, local_years_at_post: 0)
      expect(post.local_badge).to eq("近所歴1年未満")
    end

    it "近所歴が年数ありなら年数を表示" do
      post = build(:post, local_years_at_post: 3)
      expect(post.local_badge).to eq("近所歴3年")
    end
  end

  describe "#snapshot_local_years" do
    let(:user) { create(:user) }
    it "投稿者がいないなら表示されない" do
      post = create(:post, user: nil)
      expect(post.local_years_at_post).to be_nil
    end

    it "居住地が一致しないなら表示されない" do
      build(:residence, user: user, prefecture: "東京都", city: "江東区").save(validate: false)
      post = create(:post, user: user)
      expect(post.local_years_at_post).to be_nil
    end
  end
end

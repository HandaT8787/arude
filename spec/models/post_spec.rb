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

    it "居住地が一致して居住歴が3年なら" do
      travel_to(Date.new(2026, 9, 4)) do
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2023, 1, 1))
        post = create(:post, user: user)
        expect(post.local_years_at_post).to eq(3)
      end
    end

    it "同じ居住地が2つ以上あれば居住歴を合算する" do
      travel_to(Date.new(2026, 9, 4)) do
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2020, 1, 1), ended_on: Date.new(2021, 6, 30))
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2025, 2, 1), ended_on: nil)
        post = create(:post, user: user)
        expect(post.local_years_at_post).to eq(3)
      end
    end

    it "居住歴が1年未満なら0" do
      travel_to(Date.new(2026, 9, 4)) do
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2026, 2, 1), ended_on: nil)
        post = create(:post, user: user)
        expect(post.local_years_at_post).to eq(0)
      end
    end

    it "過去の居住地のみ一致するなら居住歴表示" do
      travel_to(Date.new(2026, 9, 4)) do
        create(:residence, user: user, prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2023, 1, 1), ended_on: Date.new(2025, 1, 30))
        post = create(:post, user: user)
        expect(post.local_years_at_post).to eq(2)
      end
    end
  end
end

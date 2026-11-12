require 'rails_helper'

RSpec.describe Visit, type: :model do
  let(:user) { create(:user) }
  let(:target_post) { create(:post) }

  describe "バリデーション" do
    it "visited_atが必須" do
      visit = build(:visit, user: user, post: target_post, visited_at: nil)
      expect(visit).to be_invalid
      expect(visit.errors[:visited_at]).to be_present
    end

    it "visited_atがあれば有効" do
      expect(build(:visit, user: user, post: target_post)).to be_valid
    end
  end

  describe "ratings_attributes" do
    it "scoreが空の評価は保存されない" do
      visit = Visit.new(
        user: user, post: target_post, visited_at: Time.current,
        ratings_attributes: [
          { category: "景色", score: "4" },
          { category: "静かさ", score: "" }
        ]
      )
      visit.save
      expect(visit.ratings.size).to eq(1)
      expect(visit.ratings.map(&:category)).to eq([ "景色" ])
    end
  end
end

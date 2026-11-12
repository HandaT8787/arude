require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe "category" do
    it "必須" do
      rating = build(:rating, category: nil)
      expect(rating).to be_invalid
      expect(rating.errors[:category]).to be_present
    end

    it "不正なカテゴリーは不可" do
      rating = build(:rating, category: "その他")
      expect(rating).to be_invalid
      expect(rating.errors[:category]).to be_present
    end

    Rating::RATING_CATEGORIES.each do |category|
      it "#{category}は有効" do
        expect(build(:rating, category: category)).to be_valid
      end
    end
  end

  describe "score" do
    it "必須" do
      rating = build(:rating, score: nil)
      expect(rating).to be_invalid
      expect(rating.errors[:score]).to be_present
    end

    [ 1, 5 ].each do |score|
      it "#{score}は有効" do
        rating = build(:rating, score: score)
        expect(rating).to be_valid
      end
    end

    [ 0, 6 ].each do |score|
      it "#{score}は無効" do
        rating = build(:rating, score: score)
        expect(rating).to be_invalid
        expect(rating.errors[:score]).to be_present
      end
    end
  end
end

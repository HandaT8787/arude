require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe "バリデーション" do
    let(:user) { create(:user) }
    let(:target_post) { create(:post) }

    before { create(:bookmark, user: user, post: target_post) }

    it "同じユーザーが同じ投稿を2回ブックマークできない" do
      duplicate = build(:bookmark, user: user, post: target_post)
      expect(duplicate).to be_invalid
    end

    it "別の投稿なら登録できる" do
      other = build(:bookmark, user: user, post: create(:post))
      expect(other).to be_valid
    end
  end
end

require 'rails_helper'

RSpec.describe PostTag, type: :model do
  describe "バリデーション" do
    let(:target_post) { create(:post) }
    let(:tag) { create(:tag) }

    before { create(:post_tag, post: target_post, tag: tag) }

    it "同じ投稿に同じタグを2回設定できない" do
      duplicate = build(:post_tag, post: target_post, tag: tag)
      expect(duplicate).to be_invalid
    end

    it "別の投稿なら登録できる" do
      other = build(:post_tag, post: create(:post), tag: tag)
      expect(other).to be_valid
    end
  end
end

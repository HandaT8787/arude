require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "#author_name" do
    context "グループなしの投稿の時" do
      it "nilを返す" do
        comment = create(:comment)
        expect(comment.author_name).to be_nil
      end
    end

    context "グループ投稿の時" do
      let(:group) { create(:group) }
      let(:author) { create(:user) }
      let(:group_post) { create(:post, user: author, group: group) }

      before { create(:group_membership, user: author, group: group) }

      it "在籍中のユーザーならusernameを返す" do
        commenter = create(:user)
        comment = create(:comment, post: group_post, user: commenter)
        expect(comment.author_name).to eq(commenter.username)
      end

      it "退会済みのユーザーなら「退会済みユーザー」を返す" do
        commenter = create(:user, :withdrawn)
        comment = create(:comment, post: group_post, user: commenter)
        expect(comment.author_name).to eq("退会済みユーザー")
      end

      it "ユーザーがいない(nil)のときは「退会済みユーザー」を返す" do
        comment = create(:comment, post: group_post, user: nil)
        expect(comment.author_name).to eq("退会済みユーザー")
      end
    end
  end

  describe "body" do
    it "必須" do
      comment = build(:comment, body: nil)
      expect(comment).to be_invalid
      expect(comment.errors[:body]).to be_present
    end
  end
end

require 'rails_helper'

RSpec.describe GroupMembership, type: :model do
  describe "バリデーション" do
    let(:user) { create(:user) }
    let(:target_group) { create(:group) }

    before { create(:group_membership, user: user, group: target_group) }

    it "同じユーザーが同じグループに2回は入れない" do
      duplicate = build(:group_membership, user: user, group: target_group)
      expect(duplicate).to be_invalid
    end

    it "別のグループには入れる" do
      other = build(:group_membership, user: user, group: create(:group))
      expect(other).to be_valid
    end

    it "roleが必須" do
      other = build(:group_membership, user: user, group: create(:group), role: nil)
      expect(other).to be_invalid
      expect(other.errors[:role]).to be_present
    end
  end

  describe "#owner?" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    it "オーナーなら true" do
      user_membership = create(:group_membership, :owner, user: user, group: group)
      expect(user_membership.owner?).to be true
    end

    it "member なら false" do
      user_membership = create(:group_membership, user: user, group: group)
      expect(user_membership.owner?).to be false
    end
  end
end

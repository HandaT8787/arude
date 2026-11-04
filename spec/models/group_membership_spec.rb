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
end

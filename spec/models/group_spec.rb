require 'rails_helper'

RSpec.describe Group, type: :model do
  describe "#owner" do
    let(:group) { create(:group) }

    it "在籍中のオーナーを返す" do
      owner = create(:user)
      create(:group_membership, :owner, group: group, user: owner)
      expect(group.owner).to eq(owner)
    end

    it "オーナーが退会済みならnilを返す" do
      owner = create(:user, :withdrawn)
      create(:group_membership, :owner, group: group, user: owner)
      expect(group.owner).to be_nil
    end

    it "オーナーがいなければnilを返す" do
      create(:group_membership, group: group, user: create(:user))
      expect(group.owner).to be_nil
    end
  end

  describe "name" do
    it "必須" do
      group = build(:group, name: nil)
      expect(group).to be_invalid
      expect(group.errors[:name]).to be_present
    end

    it "重複不可" do
      create(:group, name: "test")
      group = build(:group, name: "test")
      expect(group).to be_invalid
      expect(group.errors[:name]).to be_present
    end
  end
end

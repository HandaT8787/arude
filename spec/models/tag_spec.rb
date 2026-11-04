require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "バリデーション" do
    before { create(:tag, name: "公園") }

    it "nameが必須" do
      tag = build(:tag, name: nil)
      expect(tag).to be_invalid
      expect(tag.errors[:name]).to be_present
    end

    it "重複不可" do
      tag = build(:tag, name: "公園")
      expect(tag).to be_invalid
      expect(tag.errors[:name]).to be_present
    end

    it "10文字は可" do
      tag = build(:tag, name: "a" * 10)
      expect(tag).to be_valid
    end

    it "11文字は不可" do
      tag = build(:tag, name: "a" * 11)
      expect(tag).to be_invalid
      expect(tag.errors[:name]).to be_present
    end
  end

  describe "tag_type" do
    it "必須" do
      tag = build(:tag, tag_type: nil)
      expect(tag).to be_invalid
      expect(tag.errors[:tag_type]).to be_present
    end

    it "不正な値" do
      tag = build(:tag, tag_type: "group")
      expect(tag).to be_invalid
      expect(tag.errors[:tag_type]).to be_present
    end

    it "timeの有効" do
      tag = build(:tag, :time)
      expect(tag).to be_valid
    end
  end
end

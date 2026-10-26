require 'rails_helper'

RSpec.describe Residence, type: :model do
  describe ".days_to_years" do
    it "0日は0年になる" do
      expect(Residence.days_to_years(0)).to eq(0)
    end

    it "364日は0年になる" do
      expect(Residence.days_to_years(364)).to eq(0)
    end

    it "366日は1年になる" do
      expect(Residence.days_to_years(366)).to eq(1)
    end

    it "800日は2年になる" do
      expect(Residence.days_to_years(800)).to eq(2)
    end
  end

  describe ".years_to_str" do
    it "0年は1年未満になる" do
      expect(Residence.years_to_str(0)).to eq("1年未満")
    end

    it "1年は1年になる" do
      expect(Residence.years_to_str(1)).to eq("1年")
    end

    it "5年は5年になる" do
      expect(Residence.years_to_str(5)).to eq("5年")
    end
  end

  describe "validations" do
    describe "ended_on" do
      it "終了日が開始日より前なら無効" do
        residence = build(:residence, started_on: Date.new(2026, 9, 4), ended_on: Date.new(2026, 9, 3))
        expect(residence.valid?).to eq(false)
        expect(residence.errors[:ended_on]).to include("開始日以降の日付にしてください")
      end

      it "終了日が開始日と同じ日なら有効" do
        residence = build(:residence, started_on: Date.new(2026, 9, 4), ended_on: Date.new(2026, 9, 4))
        expect(residence.valid?).to eq(true)
      end

      it "終了日が空欄なら有効" do
        residence = build(:residence, started_on: Date.new(2026, 9, 4), ended_on: nil)
        expect(residence.valid?).to eq(true)
      end
    end
  end
end

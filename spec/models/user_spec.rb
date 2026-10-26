require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#move_to!" do
    let(:user) { create(:user) }
    it "初めての登録では、居住地が1件でき、終了日は空になる" do
      user.move_to!(prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2026, 9, 4))
      expect(user.residences.count).to eq(1)
      expect(user.current_residence.ended_on).to be_nil
    end
    
    it "別日に変更すると、前居住地の終了日が開始日の前日になる" do
      previous = create(:residence, user: user, started_on: Date.new(2020, 4, 1))
      user.move_to!(prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2026, 9, 4))
      expect(previous.reload.ended_on).to eq(Date.new(2026, 9, 3))
      expect(user.residences.count).to eq(2)
      expect(user.current_residence.city).to eq("名古屋市")
    end

    it "同日に変更すると、前居住地が削除される" do
      previous = create(:residence, user: user, started_on: Date.new(2020, 4, 1))
      user.move_to!(prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2020, 4, 1))
      expect(Residence.exists?(previous.id)).to eq(false)
      expect(user.residences.count).to eq(1)
      expect(user.current_residence.city).to eq("名古屋市")
    end

    it "前の居住地の開始日よりも前の開始日にすると削除される" do
      previous = create(:residence, user: user, started_on: Date.new(2026, 9, 4))
      user.move_to!(prefecture: "愛知県", city: "名古屋市", started_on: Date.new(2026, 9, 1))
      expect(Residence.exists?(previous.id)).to eq(false)
      expect(user.residences.count).to eq(1)
      expect(user.current_residence.city).to eq("名古屋市")
    end
  end
end
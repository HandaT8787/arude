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
end

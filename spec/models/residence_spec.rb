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
end

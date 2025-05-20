require 'rails_helper'

RSpec.describe BuildingType, type: :model do
  subject { create(:building_type) }
  # Validation tests
  it { should validate_presence_of(:key) }
  it { should validate_uniqueness_of(:key) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:max_level) }
  it { should validate_numericality_of(:max_level).is_greater_than(0) }

  # Factory test
  it "has a valid factory" do
    expect(build(:building_type)).to be_valid
  end

  # Instance methods
  describe "#cost_for_level" do
    let(:building_type) { create(:building_type) }

    it "returns the correct cost for a given level" do
      expect(building_type.cost_for_level(1)).to eq({
        "credits" => 200,
        "minerals" => 100,
        "energy" => 125
      })
    end
  end 

  describe "#construction_time_for_level" do
    let(:building_type) { create(:building_type) }

    it "returns the correct construction time for a given level" do
      expect(building_type.construction_time_for_level(1)).to eq(8.hours.to_i)
    end
  end
  
  describe "#effects_for_level" do
    let(:building_type) { create(:building_type) }

    it "returns the correct effects for a given level" do
      expect(building_type.effects_for_level(1)).to eq({
        "tax_modifier" => 0.05
      })
    end
  end
end

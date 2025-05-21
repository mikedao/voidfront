require 'rails_helper'

RSpec.describe Building, type: :model do
  # Association Tests
  it { should belong_to(:building_type) }
  it { should belong_to(:star_system) }

  # Validation Tests
  it { should validate_presence_of(:level) }
  it { should validate_numericality_of(:level).only_integer.is_greater_than(0) }
  it { should validate_presence_of(:status) }
  it { should validate_inclusion_of(:status).in_array(%w[under_construction being_demolished operational]) }

  # Factory Tests
  it "has a valid factory" do
    expect(build(:building)).to be_valid
  end

  it "has a valid factory for under construction" do
    expect(build(:building, :under_construction)).to be_valid
  end

  it "has a valid factory for being demolished" do
    expect(build(:building, :being_demolished)).to be_valid
  end
  
  # Instance Methods
  describe "#under_construction?" do
    it "returns true if the building is under construction" do
      building = build(:building, :under_construction)
      expect(building.under_construction?).to be true
    end

    it "returns false if the building is not under construction" do
      building = build(:building)
      expect(building.under_construction?).to be false
    end
  end

  describe "#operational?" do
    it "returns true if the building is operational" do
      building = build(:building, status: "operational")
      expect(building.operational?).to be true
    end

    it "returns false if the building is not operational" do
      building = build(:building, status: "under_construction")
      expect(building.operational?).to be false
    end
  end

  describe "#being_demolished?" do
    it "returns true if the building is being demolished" do
      building = build(:building, :being_demolished)
      expect(building.being_demolished?).to be true
    end

    it "returns false if the building is not being demolished" do
      building = build(:building)
      expect(building.being_demolished?).to be false
    end
  end
  
  describe "#construction_progress_percentage" do
    it "returns 0 if construction has not started" do
      building = build(:building, construction_start: nil, construction_end: nil)
      expect(building.construction_progress_percentage).to eq(0)
    end

    it "returns 100 if construction is complete" do
      building = build(:building, status: "operational")
      expect(building.construction_progress_percentage).to eq(100)
    end

    it "calculates the correct percentage for in progress construction" do
      # set specific times for predictable result
      start_time = 2.hours.ago
      end_time = 2.hours.from_now

      building = build(:building, status: "under_construction", 
                        construction_start: start_time, 
                        construction_end: end_time)

      allow(Time).to receive(:now).and_return(start_time + 2.hours)
      expect(building.construction_progress_percentage).to eq(50)
    end
  end

  describe "#demolition_progress_percentage" do
    it "returns 0 if demolition has not started" do
      building = build(:building, status: "operational")
      expect(building.demolition_progress_percentage).to eq(0)
    end

    it "calculates the correct percentage for in progress demolition" do
      # set up 1 hour demolition process, half complete
      demolition_start = 30.minutes.ago
      demolition_end = 30.minutes.from_now

      building = build(:building, :being_demolished, demolition_end: demolition_end)

      # We'll need to stub the created_at since demolition_start comes from updated_at
      allow(building).to receive(:updated_at).and_return(demolition_start)
      allow(Time).to receive(:current).and_return(demolition_start + 30.minutes)

      expect(building.demolition_progress_percentage).to eq(50)
    end
  end

  describe "#current_effect" do
    let(:building_type) { create(:building_type) }
    let(:building) { create(:building, building_type: building_type, level: 1, status: "operational") }

    it "returns the correct effect for the current level" do
      expect(building.current_effect("tax_modifier")).to eq(0.05)
    end 

    it "returns nil if the building is under construction" do
      building = build(:building, :under_construction, building_type: building_type)
      expect(building.current_effect("tax_modifier")).to be_nil
    end

    it "returns nil if the building is being demolished" do
      building = build(:building, :being_demolished, building_type: building_type)
      expect(building.current_effect("tax_modifier")).to be_nil
    end

      
  end

  describe "uniqueness validation" do
    let(:building_type) { create(:building_type, unique_per_system: true) }
    let(:star_system) { create(:star_system) }

    it "prevents creating duplicate buildings of unique type in same system" do
      create(:building, building_type: building_type, star_system: star_system)

      duplicate = build(:building, building_type: building_type, star_system: star_system)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:building_type_id]).to include("already exists in this system")
    end

    it "allows creating of buildings of unique type in different systems" do
      create(:building, building_type: building_type, star_system: create(:star_system))

      another_system = create(:star_system)
      another_building = build(:building, building_type: building_type, star_system: another_system)

      expect(another_building).to be_valid
    end

    it "allows creating buildings of non-unique type in same system" do
      non_unique_type = create(:building_type, unique_per_system: false)

      create(:building, building_type: non_unique_type, star_system: star_system)
      duplicate = build(:building, building_type: non_unique_type, star_system: star_system)

      expect(duplicate).to be_valid
    end
  end
end

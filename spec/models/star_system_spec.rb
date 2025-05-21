require 'rails_helper'

RSpec.describe StarSystem, type: :model do
  # Association tests
  it { should belong_to(:empire) }
  it { should have_many(:buildings) }
  
  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:system_type) }
  it { should validate_inclusion_of(:system_type).in_array(%w[terrestrial ocean desert tundra gas_giant asteroid_belt]) }
  it { should validate_numericality_of(:max_population).only_integer.is_greater_than(0) }
  it { should validate_numericality_of(:current_population).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:max_buildings).only_integer.is_greater_than(0) }
  it { should validate_numericality_of(:loyalty).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
  
  # Factory test
  it "has a valid factory" do
    expect(build(:star_system)).to be_valid
  end

  describe "#base_growth_rate" do
    it "returns correct growth rate for each system type" do
      expect(build(:star_system, system_type: "terrestrial").base_growth_rate).to eq(0.05)
      expect(build(:star_system, system_type: "ocean").base_growth_rate).to eq(0.04)
      expect(build(:star_system, system_type: "tundra").base_growth_rate).to eq(0.03)
      expect(build(:star_system, system_type: "desert").base_growth_rate).to eq(0.02)
      expect(build(:star_system, system_type: "gas_giant").base_growth_rate).to eq(0.01)
      expect(build(:star_system, system_type: "asteroid_belt").base_growth_rate).to eq(0.005)
    end
  end

  describe "#tax_growth_modifier" do
    let(:empire) { build(:empire) }
    let(:system) { build(:star_system, empire: empire) }

    it "returns bonus modifier for low tax rates" do
      empire.tax_rate = 0
      expect(system.tax_growth_modifier).to eq(2.0)
      
      empire.tax_rate = 20
      expect(system.tax_growth_modifier).to be_within(0.01).of(1.4)
    end

    it "returns penalty modifier for high tax rates" do
      empire.tax_rate = 80
      expect(system.tax_growth_modifier).to be_within(0.01).of(-0.4)
      
      empire.tax_rate = 100
      expect(system.tax_growth_modifier).to eq(-1.0)
    end
  end

  describe "#calculate_growth" do
    let(:empire) { build(:empire, tax_rate: 30) }
    let(:system) { build(:star_system, system_type: "terrestrial", empire: empire, current_population: 100) }

    it "calculates growth based on system type and tax modifier" do
      # With 30% tax rate, modifier should be approximately 1.1
      # Terrestrial base growth is 5%
      # So growth should be about 5% * 1.1 = 5.5% of 100 = 5.5 people
      expect(system.calculate_growth).to eq(5) # Rounded down
    end
    
    it "returns negative growth when conditions are harsh" do
      empire.tax_rate = 90
      # With 90% tax rate, modifier should be -0.7
      # Terrestrial base growth is 5%
      # So growth should be about 5% * -0.7 = -3.5% of 100 = -3.5 people
      expect(system.calculate_growth).to eq(-3) # Rounded down
    end
  end
  
  describe "#new_population" do

    it "calculates population based on calculated growth increase" do
      empire = build(:empire, tax_rate: 20)
      system = build(:star_system, 
                      system_type: "terrestrial", 
                      current_population: 100, 
                      max_population: 200, 
                      empire: empire)
                      
      expect(system.new_population).to eq(106)
    end
    
    it "calculates population based on calculated growth decrease" do
      empire = build(:empire, tax_rate: 100)
      system = build(:star_system, 
                      system_type: "terrestrial", 
                      current_population: 100, 
                      max_population: 200, 
                      empire: empire)
                      
      expect(system.new_population).to eq(95)
    end
    
    it "does not exceed max population" do
      empire = build(:empire, tax_rate: 20)
      system = build(:star_system, 
                      system_type: "terrestrial", 
                      current_population: 195, 
                      max_population: 200, 
                      empire: empire)
      
      expect(system.new_population).to eq(200)
    end
    
    it "does not drop below 1 population" do
      empire = build(:empire, tax_rate: 100)
      system = build(:star_system, 
                      system_type: "terrestrial", 
                      current_population: 1, 
                      max_population: 200, 
                      empire: empire)
      
      expect(system.new_population).to eq(1)
    end
  end

  describe "#buildings_count" do
    let(:system) { create(:star_system) }
    let(:building_type) { create(:building_type, unique_per_system: false) }

    it "returns the number of operational buildings" do
      create(:building, star_system: system, status: "operational", building_type: building_type)
      create(:building, star_system: system, status: "operational", building_type: building_type)
      create(:building, :under_construction, star_system: system, building_type: building_type)

      expect(system.buildings_count).to eq(2)
    end
  end

  describe "tax_modifier from buildings" do
    let(:system) { build(:star_system) }
    let(:building_type) { create(:building_type) }

    it "returns 0 when there are no buildings" do
      expect(system.tax_modifier_from_buildings).to eq(0)
    end

    it "calculates tax modifier from operational buildings" do
      create(:building, 
              star_system: system, 
              status: "operational", 
              building_type: building_type, 
              level: 1)

      expect(system.tax_modifier_from_buildings).to eq(0.05)
    end

    it "ignores buildings under construction" do
      create(:building, :under_construction, 
              star_system: system,  
              building_type: building_type, 
              level: 1)

      expect(system.tax_modifier_from_buildings).to eq(0)
    end
    
    it "ignores buildings being demolished" do
      create(:building, :being_demolished, 
              star_system: system,  
              building_type: building_type, 
              level: 1)

      expect(system.tax_modifier_from_buildings).to eq(0)
    end
    
    it "calculates tax modifier from multiple buildings" do
      building_type_2 = create(:building_type, key: "tax_office", level_data: { "1" => { effects: { tax_modifier: 0.03 }}})
      create(:building, star_system: system, status: "operational", building_type: building_type, level: 1)
      create(:building, star_system: system, status: "operational", building_type: building_type_2, level: 1)

      expect(system.tax_modifier_from_buildings).to eq(0.08)
    end
  end
end

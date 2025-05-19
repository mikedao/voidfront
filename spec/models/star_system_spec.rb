require 'rails_helper'

RSpec.describe StarSystem, type: :model do
  # Association tests
  it { should belong_to(:empire) }
  
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
  describe "#grow_population" do
    let(:empire) { build(:empire) }

    it "increases population based on calculated growth" do
      system = build(:star_system, current_population: 100, max_population: 200, empire: empire)
      allow(system).to receive(:calculate_growth).and_return(10)
      
      system.grow_population
      expect(system.current_population).to eq(110)
    end
    
    it "decreases population with negative growth" do
      system = build(:star_system, current_population: 100, max_population: 200, empire: empire)
      allow(system).to receive(:calculate_growth).and_return(-20)
      
      system.grow_population
      expect(system.current_population).to eq(80)
    end
    
    it "does not exceed max population" do
      system = build(:star_system, current_population: 195, max_population: 200, empire: empire)
      allow(system).to receive(:calculate_growth).and_return(10)
      
      system.grow_population
      expect(system.current_population).to eq(200)
    end
    
    it "does not drop below 1 population" do
      system = build(:star_system, current_population: 5, max_population: 200, empire: empire)
      allow(system).to receive(:calculate_growth).and_return(-10)
      
      system.grow_population
      expect(system.current_population).to eq(1)
    end
    
    it "saves the changes to the database" do
      system = create(:star_system, current_population: 100, max_population: 200, empire: empire)
      allow(system).to receive(:calculate_growth).and_return(10)
      
      expect { system.grow_population }.to change { system.reload.current_population }.from(100).to(110)
    end
  end
end

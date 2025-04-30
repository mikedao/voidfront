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
end
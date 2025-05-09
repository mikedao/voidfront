require 'rails_helper'

RSpec.describe Empire, type: :model do
  subject { create(:empire) }
  
  # Association tests
  it { should belong_to(:user) }
  it { should have_many(:star_systems)}
  
  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name)}
  it { should validate_numericality_of(:credits).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:minerals).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:energy).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:food).only_integer.is_greater_than_or_equal_to(0) }
  
  # Factory test
  it "has a valid factory" do
    expect(build(:empire)).to be_valid
  end

  # Default values test
  describe "default values" do
    it "sets default resource values when created without specifying them" do
      user = create(:user)
      empire = Empire.create(name: "Test Empire", user: user)
      
      expect(empire.credits).to eq(1000)
      expect(empire.minerals).to eq(500)
      expect(empire.energy).to eq(500)
      expect(empire.food).to eq(500)
    end
  end

  # Instance method tests
  describe "#resources_summary" do
    it "returns a formatted string of resources" do
      empire = build(:empire, credits: 1000, minerals: 500, energy: 500, food: 500)
      expect(empire.resources_summary).to eq("Credits: 1000 | Minerals: 500 | Energy: 500 | Food: 500")
    end
  end
end
require 'rails_helper'

RSpec.describe EmpireBuilderService do
  describe "#create_empire" do
    let(:user) { create(:user) }

    it "creates an empire for the user" do
      expect {
        EmpireBuilderService.new(user).create_empire
      }.to change(Empire, :count).by(1)
    end
    
    it "generates a name for the empire if none provided" do
      empire = EmpireBuilderService.new(user).create_empire
      expect(empire.name).not_to be_nil
    end
    
    it "creates a starting star system for the empire" do
      empire = EmpireBuilderService.new(user).create_empire
      expect(empire.star_systems.count).to eq(1)
    end
    
    it "creates a terrestrial type star system" do
      empire = EmpireBuilderService.new(user).create_empire
      expect(empire.star_systems.first.system_type).to eq("terrestrial")
    end
    
    it "uses the provided name if given" do
      empire = EmpireBuilderService.new(user).create_empire("Custom Empire")
      expect(empire.name).to eq("Custom Empire")
    end

  end
end
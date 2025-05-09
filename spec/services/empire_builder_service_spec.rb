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

    xit "returns empire with errors if name is not unique" do
      create(:empire, name: "Duplicate Empire")

      empire = EmpireBuilderService.new(user).create_empire("Duplicate Empire")

      expect(empire.errors[:name]).to include("has already been taken")
      expect(empire).not_to be_persisted
    end 

    it "generates unique names if random names clash" do
      5.times do 
        other_user = create(:user)
        EmpireBuilderService.new(other_user).create_empire
      end

      empire = EmpireBuilderService.new(user).create_empire

      expect(empire).to be_valid
      expect(empire).to be_persisted
    end
  end
end
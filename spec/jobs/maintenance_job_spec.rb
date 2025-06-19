require 'rails_helper'

RSpec.describe MaintenanceJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }
  let!(:empire) { create(:empire, user: user, credits: 1000, tax_rate: 10) }
  let!(:star_system) { create(:star_system, empire: empire, current_population: 500) }
  let!(:star_system_2) { create(:star_system, empire: empire, current_population: 300) }
  let!(:building_type) { create(:building_type) }

  describe "#perform" do
    it 'collects taxes based on population and tax rate' do
      expect {
        MaintenanceJob.perform_now(empire.id)
      }.to change { empire.reload.credits }.by(80)
    end

    it 'doesnt collect taxes if the tax rate is 0' do
      empire.update(tax_rate: 0)
      expect {
        MaintenanceJob.perform_now(empire.id)
      }.not_to change { empire.reload.credits }
    end
  end

  describe "population growth during maintenance" do
    let(:user) { create(:user) }
    let(:empire) { create(:empire, user: user, tax_rate: 20) }
    let(:star_system) { create(:star_system, empire: empire, current_population: 500, system_type: "terrestrial") }
  
    it "grows the population of each star system" do
      system = create(:star_system, empire: empire, current_population: 500, system_type: "terrestrial")
      expect {
        MaintenanceJob.perform_now(empire.id)
      }.to change { system.reload.current_population }
    end
  end

  describe "handling building status updates" do
    let(:user) { create(:user) }
    let(:empire) { create(:empire, user: user) }
    let(:star_system) { create(:star_system, empire: empire) }
    let(:building_type) { create(:building_type) }

    it "completes buildings whose construction time has passed" do
      building = create(:building, 
                        star_system: star_system, 
                        building_type: building_type, 
                        construction_end: 1.minute.ago)

      MaintenanceJob.perform_now(empire.id)

      expect(building.reload.status).to eq("operational")
    end

    it "doesn't complete buildings that haven't finished construction" do
      building = create(:building, :under_construction,
                        star_system: star_system, 
                        building_type: building_type, 
                        construction_end: 1.hour.from_now)

      MaintenanceJob.perform_now(empire.id)

      expect(building.reload.status).to eq("under_construction")
    end

    it "removes buildings that have been demolished" do
      building = create(:building, :being_demolished,
                        star_system: star_system,
                        building_type: building_type,
                        demolition_end: 1.minute.ago)

      expect { MaintenanceJob.perform_now(empire.id) }.to change { Building.count }.by(-1)
    end

    it "doesn't remove buildings still being demolished" do
      building = create(:building, :being_demolished,
                        star_system: star_system,
                        building_type: building_type,
                        demolition_end: 1.hour.from_now)

      expect { MaintenanceJob.perform_now(empire.id) }.not_to change { Building.count }
      expect(building.reload.status).to eq("being_demolished")
    end
  end
end

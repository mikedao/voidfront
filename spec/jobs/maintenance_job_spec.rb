require 'rails_helper'

RSpec.describe MaintenanceJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }
  let!(:empire) { create(:empire, user: user, credits: 1000, tax_rate: 10) }
  let!(:star_system) { create(:star_system, empire: empire, current_population: 500) }
  let!(:star_system_2) { create(:star_system, empire: empire, current_population: 300) }

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
end

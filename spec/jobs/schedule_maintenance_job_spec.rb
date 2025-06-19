# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleMaintenanceJob, type: :job do
  include ActiveJob::TestHelper

  let!(:empire) { create(:empire) }
  let!(:empire2) { create(:empire) }

  describe '#perform' do
    it 'enqueues a maintenance job for each empire' do
      expect do
        ScheduleMaintenanceJob.perform_now
      end.to change { enqueued_jobs.size }.by(2)

      expect(enqueued_jobs.map { |job| job[:args][0] }).to include(empire.id, empire2.id)
      expect(enqueued_jobs.map { |job| job[:job].to_s }).to all(eq 'MaintenanceJob')
    end

    it 'does not fail if there are no eimpires' do
      Empire.destroy_all

      expect do
        ScheduleMaintenanceJob.perform_now
      end.not_to raise_error
    end
  end
end

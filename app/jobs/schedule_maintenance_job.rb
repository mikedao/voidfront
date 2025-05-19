class ScheduleMaintenanceJob < ApplicationJob
  queue_as :default

  def perform
    Empire.find_each(batch_size: 100) do |empire|
      begin
        MaintenanceJob.perform_later(empire.id)
      rescue StandardError => e
        Rails.logger.error("Failed to schedule maintenance for Empire #{empire.id}: #{e.message}")
      end
    end
  end
end

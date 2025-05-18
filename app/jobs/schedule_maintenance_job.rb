class ScheduleMaintenanceJob < ApplicationJob
  queue_as :default

  def perform
    Empire.pluck(:id).each do |empire_id|
      MaintenanceJob.perform_later(empire_id)
    end
  end
end

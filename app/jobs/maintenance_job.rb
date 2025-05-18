class MaintenanceJob < ApplicationJob
  queue_as :default

  def perform(empire_id)
    @empire = Empire.find(empire_id)
    return unless @empire
  
    maintenance_tasks 
  end

  private

  def maintenance_tasks
    ActiveRecord::Base.transaction do
      @empire.update(credits: @empire.credits + tax_revenue) if tax_revenue > 0
    end
  end

  def tax_revenue
    total_population = @empire.star_systems.sum(:current_population)
    (total_population * @empire.tax_rate / 100).floor
  end
end

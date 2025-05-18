class MaintenanceJob < ApplicationJob
  queue_as :default

  def perform(empire_id)
    @empire = Empire.find(empire_id)
    return unless @empire
  
    collect_taxes
    
    # Future maintenance tasks go here
  end

  private

  def collect_taxes
    total_population = @empire.star_systems.sum(:current_population)
    tax_revenue = (total_population * @empire.tax_rate / 100).floor

    if tax_revenue > 0
      @empire.update(credits: @empire.credits + tax_revenue)
    end
  end
end

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

      @empire.star_systems.each do |system|
        system.update(current_population: system.new_population)
      end
    end
  end

  def tax_revenue
    # Calculate tax income for each star system and sum them up 
    @empire.star_systems.sum do |system|
      system.calculate_tax_income
    end
  end
end

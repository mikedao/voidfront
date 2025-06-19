# frozen_string_literal: true

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
      # handle building status updates
      update_building_statuses

      # collect tax revenue
      @empire.update(credits: @empire.credits + tax_revenue) if tax_revenue.positive?

      # update population
      @empire.star_systems.each do |system|
        system.update(current_population: system.new_population)
      end
    end
  end

  def update_building_statuses
    @empire.star_systems.each do |system|
      # Find buildings where construction has finished
      system.buildings.where(status: 'under_construction')
            .where('construction_end <= ?', Time.current)
            .update_all(status: 'operational')

      # Remove buildings where demolition has finished
      system.buildings.where(status: 'being_demolished')
            .where('demolition_end <= ?', Time.current)
            .destroy_all
    end
  end

  def tax_revenue
    # Calculate tax income for each star system and sum them up
    @empire.star_systems.sum(&:calculate_tax_income)
  end
end

class BuildingsController < ApplicationController
  before_action :set_building, only: [:destroy]
  before_action :authorize_building, only: [:destroy]


  def create
    Rails.logger.debug "BuildingsController#create called with params: #{params.inspect}"
    
    star_system = StarSystem.find(params[:building][:star_system_id])
    building_type = BuildingType.find(params[:building][:building_type_id])

    # check authorization
    unless star_system.empire == current_user.empire
      redirect_to root_path, alert: "You do not have permission to build in this star system."
      return
    end

    # check if at max buildings
    if star_system.buildings.where(status: ["operational", "under_construction"]).count >= star_system.max_buildings
      redirect_to edit_star_system_path(star_system), alert: "Maximum buildings reached"
      return
    end

    # check if unique building already exists
    if building_type.unique_per_system && star_system.buildings.where(building_type: building_type).exists?
      redirect_to edit_star_system_path(star_system), alert: "This building type already exists in this star system"
      return
    end

    # check resources
    cost = building_type.cost_for_level(1)
    empire = current_user.empire
    
    if empire.credits < cost["credits"] || empire.minerals < cost["minerals"] || empire.energy < cost["energy"]
      redirect_to edit_star_system_path(star_system), alert: "Insufficient Resources"
      return
    end

    # all checks pass, good to go
    construction_time = building_type.construction_time_for_level(1)

    ActiveRecord::Base.transaction do
      # Deduct resources
      empire.update!(
        credits: empire.credits - cost["credits"],
        minerals: empire.minerals - cost["minerals"],
        energy: empire.energy - cost["energy"]
      )
      
      # Create building
      building = Building.create!(
        star_system: star_system,
        building_type: building_type,
        level: 1,
        status: "under_construction",
        construction_start: Time.current,
        construction_end: Time.current + construction_time
      )
    end

    redirect_to edit_star_system_path(star_system), notice: "Building construction started"

  rescue => e
    redirect_to edit_star_system_path(@star_system), alert: "Error starting construction: #{e.message}"
  end

  def destroy
    @building.update(
      status: "being_demolished",
      demolition_end: Time.current + @building.building_type.demolition_time_for_level(@building.level)
    )
    
    redirect_to edit_star_system_path(@building.star_system), notice: "Building demolition started"
  end


  private
    def set_building
      @building = Building.find(params[:id])
    end

    def authorize_building
      unless @building.star_system.empire == current_user.empire
        redirect_to root_path, alert: "You do not have permission to demolish this building"
      end
    end
end

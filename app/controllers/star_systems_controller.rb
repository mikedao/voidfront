class StarSystemsController < ApplicationController
  before_action :authorize_star_system

  def edit
    @star_system = StarSystem.find(params[:id])
  end

  def update
    @star_system = StarSystem.find(params[:id])
    if @star_system.update(star_system_params)
      redirect_to edit_star_system_path(@star_system), notice: "Star system updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def star_system_params
    params.require(:star_system).permit(:name)
  end

  def authorize_star_system
    @star_system = StarSystem.find(params[:id])
    unless @star_system.empire == current_user.empire
      redirect_to root_path, alert: "You do not have permission to administer this star system"
    end
  end
end

class EmpiresController < ApplicationController
  def edit
    @empire = current_user.empire
  end

  def update
    @empire = current_user.empire
    if @empire.update(empire_params)
      redirect_to dashboard_path, notice: "Empire updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def empire_params
    params.require(:empire).permit(:name, :tax_rate)
  end
end

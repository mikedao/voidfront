class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      empire_name = params[:user][:empire_name].presence
      empire = EmpireBuilderService.new(@user).create_empire(empire_name)

      if empire.errors.any?
        @user.destroy
        @user.errors.add(:empire_name, empire.errors.messages[:name].first) if empire.errors.messages[:name].present?
        return render :new, status: :unprocessable_entity
      end
      
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Registration Successful"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
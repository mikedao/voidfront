class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      if params[:remember_me] == '1'
        cookies.permanent.encrypted[:user_id] = user.id
      end
      redirect_to root_path, notice: "Login Successful"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.permanent.encrypted[:user_id] = nil
    redirect_to root_path, notice: "You have been logged out"
  end
end
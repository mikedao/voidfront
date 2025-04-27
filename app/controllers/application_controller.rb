class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user, :user_signed_in?
  
  private
  
    def current_user
      @current_user ||= if session[:user_id]
                          User.find_by(id: session[:user_id])
                        elsif cookies.encrypted[:user_id]
                          user = User.find_by(id: cookies.encrypted[:user_id])
                          if user
                            session[:user_id] = user.id
                            user
                          end
                        end
    end
    
    def user_signed_in?
      !current_user.nil?
    end
    
    def require_login
      redirect_to root_path, alert: "You must be logged in to access this page." unless user_signed_in?
    end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def index
  end

  protected

  def after_sign_in_path_for(resource)
    session[:path] || user_path
  end

  def configure_permitted_parameters

    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :contact_number, :college_name, :enrollment_number, :engineering_branch) }
    
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :contact_number, :college_name, :enrollment_number, :engineering_branch, :current_password, :deleted ) }
  end

  def set_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate" 
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end

end

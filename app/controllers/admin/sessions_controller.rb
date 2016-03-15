class Admin::SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    admin = Admin.find_by(email: auth["info"]["email"])
    if admin.nil?
      redirect_to admin_root_path, alert: "You don't have access. Contact Super Admin"
    else
      url = session.delete(:return_to) || admin_home_path
      url = admin_home_path if url.eql?(logout_path)
      admin.set_oauth_information(auth)
      if admin.save
        session[:admin_id] = admin.id
        notice = "Signed in!"
        logger.debug "URL to redirect to: #{ url }"
        redirect_to url, notice: notice
      else
        redirect_to admin_root_path, notice: 'Failed to login'
      end
    end
  end

  def destroy
    reset_session
    redirect_to admin_root_path, notice: "Logged out!"
  end

end

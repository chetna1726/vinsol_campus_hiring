class Admin::DashboardController < Admin::AdminsController
  skip_before_action :authorize

  def show
  end

end

class Admin::AdminsController < ApplicationController

  before_action :authorize
  before_action :if_super_admin, except: [:show]
  before_action :get_admin, only: [:edit, :update, :destroy]

  helper_method :current_admin

  rescue_from ActiveRecord::DeleteRestrictionError, with: :cannot_delete_admin

  def index
    @admins = Admin.where(super_admin: false)
  end

  def show
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      redirect_to admins_path, notice: "Admin #{ @admin.email } created successfully"
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @admin.update(admin_params)
      redirect_to admins_path, notice: "Admin #{ @admin.email } updated successfully"
    else
      render action: :edit
    end
  end

  def destroy
    unless @admin.super_admin?
      @admin.destroy
      redirect_to admins_path, notice: "Admin #{ @admin.email } deleted successfully"
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:email, :name)
  end

  def get_admin
    @admin = Admin.find_by(id: params[:id])
    if @admin.nil?
      redirect_to admins_path, alert: "Admin doesn't exist"
    end
  end

  def current_admin
    @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end

  def authorize
    if !current_admin
      redirect_to admin_root_path, alert: "Please log in"
    end
  end

  def if_super_admin
    unless current_admin.super_admin?
      redirect_to admin_home_path, alert: 'You Are Not Super Admin'
    end
  end

  def cannot_delete_admin
    redirect_to admins_path, alert: "Admin #{ @admin.email } cannot be deleted. Has dependent questions"
  end

end

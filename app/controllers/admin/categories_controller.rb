class Admin::CategoriesController < Admin::AdminsController

  skip_before_action :if_super_admin, :get_admin

  before_action :set_category, only: [:edit, :update, :destroy, :questions]
  before_action :set_root_categories, only: [:new, :create]
  before_action :exclude_self_from_parent_categories, only: [:edit, :update]
  
  rescue_from ActiveRecord::DeleteRestrictionError, with: :cannot_delete_category
  
  def index
    @categories = Category.includes(:parent).page(params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category #{ @category.name } was successfully created."
    else
      render action: :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category #{ @category.name } was successfully updated."
    else
      render  action: :edit
    end
  end

  def edit
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: "Category #{ @category.name } was successfully deleted"
  end

  def questions
  end
  
  private

  def set_category
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      redirect_to admin_root_path, alert: "Category doesn't exist"
    end
  end

  def set_root_categories
    @categories = Category.root_all
  end

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end

  def exclude_self_from_parent_categories
    @categories = Category.root_all - [@category]
  end

  def cannot_delete_category
    redirect_to admin_categories_path, alert: "Category cannot be deleted it has dependent sub categories and questions"
  end

end
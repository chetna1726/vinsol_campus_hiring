class Admin::DifficultyLevelsController < Admin::AdminsController

  skip_before_action :if_super_admin, :get_admin

  before_action :set_difficulty_level, only: [:edit, :update, :destroy, :questions]
  
  rescue_from ActiveRecord::DeleteRestrictionError, with: :cannot_delete_difficulty_level
  
  def index
    @difficulty_levels = DifficultyLevel.all
  end

  def new
    @difficulty_level = DifficultyLevel.new
  end

  def create
    @difficulty_level = DifficultyLevel.new(difficulty_level_params)
    if @difficulty_level.save
      redirect_to admin_difficulty_levels_path, notice: "Difficulty Level #{ @difficulty_level.name } was successfully created."
    else
      render action: :new
    end
  end

  def update
    if @difficulty_level.update(difficulty_level_params)
      redirect_to admin_difficulty_levels_path, notice: "Difficulty Level #{ @difficulty_level.name } was successfully updated."
    else
      render  action: :edit
    end
  end

  def edit
  end
  
  def destroy
    @difficulty_level.destroy
    redirect_to admin_difficulty_levels_path, notice: "Difficulty Level #{ @difficulty_level.name } was successfully deleted"
  end

  def questions
    @questions = @difficulty_level.questions.page(params[:page])
  end

  private

  def set_difficulty_level
    @difficulty_level = DifficultyLevel.find_by(id: params[:id])
    if @difficulty_level.nil?
      redirect_to admin_difficulty_root_path, alert: "Difficulty Level doesn't exist"
    end
  end

  def difficulty_level_params
    params.require(:difficulty_level).permit(:name)
  end

  def cannot_delete_difficulty_level
    redirect_to admin_difficulty_levels_path, alert: "Difficulty Level cannot be deleted it has dependent questions"
  end

end

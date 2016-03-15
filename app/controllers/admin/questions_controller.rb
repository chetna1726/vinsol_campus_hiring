class Admin::QuestionsController < Admin::AdminsController
  
  skip_before_action :if_super_admin, :get_admin

  before_action :ensure_valid_question_type, only: [:create, :update]
  before_action :get_question, only: [:edit, :update, :destroy]

  def index
    search_text = (params[:search] ? params[:search] : '')
    @questions = Question.search( Riddle.escape(search_text), include: [ :options, :difficulty_level, { category: [:parent] } ], order: :parent_category, field_weights: { parent_category: 10, category: 6, content: 3 }, page: params[:page], per_page: QUESTION[:per_page])
  end

  def show
    @question = Question.includes(:options, :difficulty_level, category: [:parent]).find_by(id: params[:id])
  end

  def new
    @question = Question.new(type: params[:question_type], status: 'active')
  end

  def create
    @question = current_admin.questions.new(question_params)
    if @question.save
      redirect_to admin_question_path(@question)
    else
      render action: :new
    end
  end

  def update
    if @question.update(question_params)
        redirect_to admin_question_path(@question), notice: "Question was successfully updated."
      else
        render  action: :edit
      end
  end

  def destroy 
    if @question.destroy
      redirect_to admin_questions_path, notice: "Question was successfully deleted"
    else
      redirect_to admin_questions_path, alert: 'Cannot delete question, it is included in some quiz'
    end
  end

  private

  def question_params
    params.require(:question).permit(:type, :content, :category_id, :difficulty_level_id, :status, :points, :image, :image_delete, options_attributes: [:id, :_destroy, :value, :answer])
  end

  def new_question_params
    params.require(:question_type)
  end


  def get_question
    @question = Question.find_by(id: params[:id])
    unless @question
      redirect_to admin_root_path, alert: "Question doesn't exist"
    end
  end

  def ensure_valid_question_type
    unless (Question::TYPES).include?(params[:question][:type])
      redirect_to admin_questions_path, alert: "Invalid question type #{ params[:question][:type] }"
    end
  end
  
end
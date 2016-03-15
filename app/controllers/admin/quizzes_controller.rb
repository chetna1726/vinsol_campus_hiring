class Admin::QuizzesController < Admin::AdminsController

  skip_before_action :if_super_admin, :get_admin
  
  before_action :set_quiz, only: [:email_results, :remove_question, :export_results_to_csv, :show_results, :update_questions, :show, :choose_questions, :edit, :update, :destroy, :add_questions_automatically]

  rescue_from ActiveRecord::DeleteRestrictionError, with: :cannot_delete_quiz

  def index
    respond_to do |format|
      format.html do
        @quizzes = Quiz.attemptable(true).not_expired.page(params[:page])
      end
      format.js do
        if params[:attemptable].present?
          @quizzes = Quiz.attemptable(params[:attemptable])
        end
        if params[:expired].present?
          @quizzes = (params[:expired].to_i == 1) ? @quizzes.expired : @quizzes.not_expired
        end
        @quizzes = @quizzes.page(params[:page])
      end
    end
  end
  
  def show
  end

  def new
    @quiz = Quiz.new(start_date_time: DateTime.current, end_date_time: DateTime.current )
  end

  def create
    @quiz = current_admin.quizzes.new(quiz_params)
    if @quiz.save
      redirect_to admin_quiz_path(@quiz), notice: "Quiz #{ @quiz.name } is successfully created, Please Add Questions"
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @quiz.update(quiz_params)
      redirect_to admin_quiz_path(@quiz), notice: "Quiz #{ @quiz.name } is successfully updated"
    else
      render action: :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to admin_quizzes_path, notice: "Quiz #{ @quiz.name } was successfully deleted"
  end

  def add_questions_automatically
    respond_to do |format|
      format.html {}
      format.js do
        number_of_questions = params['num_questions'].to_i
        if number_of_questions > 0
          questions = (Question.includes(:difficulty_level, category: [:parent]).where(params['filterHash']) - @quiz.questions).sort_by{rand}.slice(0..(number_of_questions - 1))
          @quiz.questions << questions
          if number_of_questions > questions.length
            @fetched = questions.length
          end
        end
      end
    end
  end

  def remove_question
    @quiz.questions.delete(params[:question_id])
  end

  def choose_questions
    @question_types = Question::TYPES
    @number_of_questions = @quiz.number_of_questions - @quiz.questions.length
    @questions = Question.includes(:difficulty_level, category: [:parent]).page(params[:page])
    respond_to do |format|
      format.html {}
      format.js do
        if params['filterHash'].present?
          @questions = @questions.where(params['filterHash']).page(params[:page])
        end
      end
    end
  end
  
  def update_questions
    if (params[:add] == true.to_s)
      unless @quiz.questions << Question.find(params[:question_id])
        render text: 'error'
        return
      end
    else
      @quiz.questions.delete(params[:question_id])
    end
    render text: @quiz.marks
  end

  def show_questions
    @quiz = Quiz.includes(questions: [:category]).find_by(id: params[:id])
  end

  def results
    @quizzes = Quiz.attemptable(true).order(start_date_time: :desc, name: :asc)
  end

  def show_results
    @results = @quiz.results.order("score desc, users.first_name asc, users.last_name asc")
    respond_to do |format|
      format.html {}
      format.js do
        if params[:sort_by] == 'Name'
          @results = @results.order("users.first_name #{ params[:order] }, users.last_name #{ params[:name] }")
        else params[:sort_by] == 'Score'
          @results = @results.order("score  #{ params[:order] }")
        end
      end
    end
  end
  
  def export_results_to_csv
    send_data @quiz.to_csv, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{ @quiz.name }-results.csv" 
  end

  def email_results
    QuizMailer.delay.send_results(current_admin, @quiz)
    redirect_to show_results_admin_quiz_path(@quiz), notice: "You will receive an email with the results"
  end

  private

  def quiz_params
    params.require(:quiz).permit(:name, :start_date_time, :end_date_time, :duration_in_minutes, :instructions, :number_of_questions, :shuffle_questions, :shuffle_options, :negative_marking)
  end

  def set_quiz
    @quiz = Quiz.find_by(id: params[:id])
    if @quiz.nil?
      redirect_to admin_root_path, alert: "Quiz doesn't exist"
    end
  end

  def cannot_delete_quiz
    redirect_to admin_quizzes_path, alert: "Quiz #{ @quiz.name } cannot be deleted it has been attempted"
  end

end

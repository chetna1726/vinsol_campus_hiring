class QuizzesController < UsersController
  before_action :set_session_path
  before_action :set_no_cache
  before_action :authenticate_user!
  before_action :set_quiz, only: [:next_question, :show_instructions, :update_timer, :show_questions, :show, :check_passcode]
  before_action :validate_quiz, except: :finish_quiz
  before_action :validate_passcode, except: [:show, :check_passcode, :finish_quiz]
  before_action :setup_quiz, only: [:show_questions]
  before_action :record_user_answer, only: [:next_question]
  before_action :set_current_question, only: [:show_questions, :next_question]
  after_action :clear_session_path

  def show
    if current_user.assigned_quizzes.attempted.find_by(quiz_id: @quiz.id)
      redirect_to user_path, alert: 'You have already taken this quiz'
    end
  end

  def check_passcode
    if @quiz.validate_passcode(params[:quiz][:passcode])
      session[:passcode] = params[:quiz][:passcode]
      redirect_to instructions_path(@quiz.code)
    else
      redirect_to quiz_path(@quiz.code), alert: 'Invalid passcode'
    end
  end

  def show_instructions
  end

  def show_questions
    if @current_question.nil?
      redirect_to user_path, alert: 'You have taken the quiz'
    else
      @assigned_quiz.increment!(:number_of_attempts)
    end
  end

  def next_question
    @assigned_quiz = current_user.assigned_quizzes.by_quiz(@quiz.id)
    if @current_question.nil?
      current_user.finish_quiz(@quiz)
      render text: finish_quiz_url, status: 302
    end
  end

  def finish_quiz
    session[:current_question] = nil
    session[:passcode] = nil
  end

  def update_timer
    @assigned_quiz = current_user.assigned_quizzes.by_quiz(@quiz.id)
    @assigned_quiz.decrement!(:time, QUIZ[:update_timer_interval])
    if @assigned_quiz.time <= 0
      record_user_answer
      current_user.finish_quiz(@quiz)
      render text: finish_quiz_url, status: 302
    else
      render text: "#{@assigned_quiz.time}"
    end
  end 

  private

  def set_quiz
    @quiz = Quiz.find_by(code: params[:code])
    if @quiz.nil?
      redirect_to user_path, alert: 'Invalid quiz url'
    end
  end

  def record_user_answer
    current_user.responses.find_by(quiz_id: @quiz.id, question_id: session[:current_question]).record_answer(params[:answer])
  end

  def setup_quiz
    @assigned_quiz = current_user.setup_quiz(@quiz)
  end

  def set_current_question
    responses = current_user.responses.by_quiz(@quiz.id).unattempted
    @remaining = responses.length - 1
    if responses[0]
      @current_question = responses[0].question
      session[:current_question] = @current_question.id
    end
  end

  def set_session_path
    session[:path] = request.url
  end

  def clear_session_path
    session[:path] = nil
  end


  def validate_passcode
    unless @quiz.validate_passcode(session[:passcode])
      redirect_to user_path, alert: "You're not authorized to access this quiz"
    end
  end

  def validate_quiz
    unless @quiz.is_valid?
      redirect_to user_path, alert: "You're not authorized to access this quiz"
    end
  end

end
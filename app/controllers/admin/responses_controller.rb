class Admin::ResponsesController < Admin::AdminsController

  def show_user_quiz_responses
    @quiz = Quiz.find_by(id: params[:quiz_id])
    @user = User.find_by(id: params[:user_id])
    @responses = Response.where(user_id: params[:user_id], quiz_id: params[:quiz_id])
  end

end

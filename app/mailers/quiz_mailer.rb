class QuizMailer < ActionMailer::Base
  default from: "from@example.com"
  def send_results(admin, quiz)
    @admin = admin
    @quiz = quiz
    attachments["#{ @quiz.name }_results.csv"] = @quiz.to_csv
    mail(to: @admin.email, subject: "Results of #{ @quiz.name }")
  end
end

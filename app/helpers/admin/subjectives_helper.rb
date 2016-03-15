module Admin::SubjectivesHelper

  def build_answer(question)
    question.options.build(answer: true) if question.options.empty?
  end

end

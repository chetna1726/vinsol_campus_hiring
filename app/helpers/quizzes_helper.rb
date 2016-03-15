module QuizzesHelper
  def link_name(remaining_questions_count)
    remaining_questions_count > 0 ? "Next Question" : "Finish Quiz"
  end

  def shuffled_options(flag, question)
    flag ? question.options.shuffle : question.options
  end
end

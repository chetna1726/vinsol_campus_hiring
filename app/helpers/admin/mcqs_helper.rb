module Admin::McqsHelper

  def build_options(question)
    QUESTION[:default_num_of_choices_mcq].times { question.options.build } if question.options.empty?
  end

end

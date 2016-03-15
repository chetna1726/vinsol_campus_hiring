class MCQ < Question

  validate :ensure_only_one_answer
  validate :ensure_atleast_two_options

  def ensure_only_one_answer
    answers_count = options.select(&:answer?).length
    if answers_count != 1
      errors.add(:answers, "Select one option as correct answer")
    end
  end

  def ensure_atleast_two_options
    if options.length < 2
      errors.add(:options, 'Specify atleast two')
    end
  end

end

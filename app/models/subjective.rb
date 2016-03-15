class Subjective < Question

  validate :ensure_one_answer

  def ensure_one_answer
    unless options.length > 1
      errors.add(:answers, 'specify atleast one')
    end
  end
end

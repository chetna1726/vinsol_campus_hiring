class Response < ActiveRecord::Base

  auto_strip_attributes :answer, squish: true

  belongs_to :user
  belongs_to :quiz
  belongs_to :question
  belongs_to :option

  validates :user_id, uniqueness: { :scope => [:quiz_id, :question_id], message: "cannot take quiz more than once"}
  validates :question_id, uniqueness: { :scope => [:quiz_id, :user_id], message: "cannot have same question in a quiz" }
  validates :quiz_id, uniqueness: { :scope => [:question_id, :user_id], message: "cannot have the same quiz for a user" }

  scope :unattempted, -> { where(attempted: false) }
  scope :by_quiz, ->(quiz_id) { where(quiz_id: quiz_id)}
  scope :attempted, -> { where(attempted: true) }

  delegate :value, to: :option, prefix: true, allow_nil: true
  
  def self.mark_unattempted(quiz_id) 
    where(quiz_id: quiz_id).unattempted.each do |response|
      response.update(attempted: true)
    end
  end

  def record_answer(value)
    unless attempted?
      if question.type == 'MCQ'
        update_attributes(option_id: value, attempted: true)
      else
        update_attributes(answer: value, attempted: true)
      end
    end
  end

  def is_correct?
    if question.type == 'MCQ'
      correct = ( question.answers[0].id == option_id)
    else
      correct = (answer.downcase).in?(question.answers.map{ |a| a.value.downcase })
    end
    correct
  end

  def marks_scored
    is_correct? ? question.points : (-1 * Float(question.points * quiz.negative_marking)/100 )
  end

  def answer_value
    (question.type == 'MCQ') ? option_value : answer
  end

end

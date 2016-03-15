class AssignedQuiz < ActiveRecord::Base

  belongs_to :user
  belongs_to :quiz

  validates :user_id, uniqueness: { scope: :quiz_id, message: "Cannot take a quiz more than once" }

  scope :find_or_create_by_quiz, ->(quiz) { find_by(quiz_id: quiz.id) || create(quiz_id: quiz.id, time: quiz.duration) }
  scope :attempted, -> { where(attempted: true) }
  scope :by_quiz, ->(quiz_id) { find_by(quiz_id: quiz_id) }
end

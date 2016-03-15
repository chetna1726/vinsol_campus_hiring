class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :contact_number, :college_name, :enrollment_number, :engineering_branch, presence: true
  validates :contact_number, format: { with: REGEX[:contact_number], message: 'Should be 10 digits'}

  auto_strip_attributes :first_name, :last_name, :email, :college_name, :enrollment_number, squish: true

  has_many :responses
  has_many :assigned_quizzes
  has_many :quizzes, through: :assigned_quizzes

  def name
    "#{ first_name } #{ last_name }"
  end

  def setup_quiz(quiz)
    assigned_quiz = assigned_quizzes.find_or_create_by_quiz(quiz)
    if responses.by_quiz(quiz.id).empty?
      quiz.shuffled_question_ids.each do |id|
        r = responses.create(quiz_id: quiz.id, question_id: id)
      end
    end
    assigned_quiz
  end

  def calculate_quiz_score(quiz)
    score = 0.0
    responses.by_quiz(quiz.id).attempted.each do |user_response|
      user_response.question.increment!(:total_hits)
      if user_response.option_id.present? || user_response.answer.present?
        score += user_response.marks_scored
        if user_response.is_correct?
          user_response.question.increment!(:successful_hits)
          user_response.update_attributes(correct: true)
        end
      end
      assigned_quizzes.by_quiz(quiz.id).update(score: score, attempted: true)
    end
  end

  def finish_quiz(quiz)
    calculate_quiz_score(quiz)
    responses.mark_unattempted(quiz.id)
    assigned_quizzes.by_quiz(quiz.id).update(attempted: true)
  end

  def current_quiz(quiz)
    assigned_quizzes.by_quiz(quiz.id)
  end

  #overrding devise methods for soft deleting users.
  def self.find_for_authentication(conditions)
    super(conditions.merge(deleted: false))
  end

  def self.find_first_by_auth_conditions(conditions)
    super(conditions.merge(deleted: false))
  end

  def soft_delete
    update(deleted: true)
  end
end

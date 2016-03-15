require "csv"

class Quiz < ActiveRecord::Base

  paginates_per QUIZ[:per_page]

  before_create :create_unique_passcode, :create_unique_code
  before_save :set_quiz_attemptable_status
  
  belongs_to :admin

  has_and_belongs_to_many :questions, before_add: :check_maximum_questions_limit, after_add: [:set_attemptable_status, :add_marks], after_remove: [:set_attemptable_status, :subtract_marks]
  has_many :assigned_to_users, class_name: 'AssignedQuiz', dependent: :restrict_with_exception
  has_many :users, through: :assigned_to_users
  has_many :responses, dependent: :restrict_with_exception

  validate :check_assigned_questions_length, if: 'number_of_questions.present?'
  validates :name, :number_of_questions, :start_date_time, :end_date_time, :duration, presence: true
  validates :name, uniqueness: { case_sensitive: false }, length: { maximum: 255 }, if: 'name.present?'
  validates :negative_marking, numericality: { less_than_or_equal_to: 100, greater_than_or_equal_to: 0 }, if: 'negative_marking.present?'
  validates :number_of_questions, numericality: { only_integer: true }, if: 'number_of_questions.present?'
  validates :duration, numericality: { only_integer: true, greater_than: 0 }

  validate :ensure_future_start_time, on: :create, if: 'start_date_time.present?'
  validate :end_date_time_should_be_greater_than_start_date_time, if: :dates_present?

  scope :expired, -> { where("end_date_time < ?", DateTime.current) }
  scope :not_expired, -> { where.not("end_date_time < ?", DateTime.current) }
  scope :attemptable, ->(status) { where(attemptable: status) }

  delegate :name, :email, to: :admin, prefix: true, allow_nil: true

  def to_csv
    csv_string = CSV.generate do |csv|
      csv << ["Name", "Email", "Mobile Number", "Score(#{ marks })"]
      csv << []
      results.each do |record|
        csv << [record.user.name, record.user.email, record.user.contact_number, record.score ]
      end
    end
  end

  def results
    assigned_to_users.attempted.includes(:user)
  end

  def shuffled_question_ids
    shuffle_questions ? question_ids.shuffle : question_ids
  end

  def validate_passcode(provided_passcode)
    passcode == provided_passcode
  end

  def duration_in_minutes
    duration/60
  end

  def duration_in_minutes=(value)
    self.duration = (value.to_i.minutes.to_i)
  end

  def is_valid?
    (valid_timing? && attemptable?)
  end

  def remaining_questions
    number_of_questions - questions.length
  end

  private

  def dates_present?
    start_date_time.present? && end_date_time.present?
  end

  def ensure_future_start_time
    if start_date_time < DateTime.current
      errors.add(:start_date_time, 'should be ahead of current date time')
    end
  end

  def end_date_time_should_be_greater_than_start_date_time
    if end_date_time < start_date_time
      errors.add(:end_date_time, 'should be greater than start date time')
    end
  end

  def create_unique_passcode
    self.passcode = generate_unique_code('passcode', QUIZ[:passcode_length])
  end

  def create_unique_code
    self.code = generate_unique_code('code', QUIZ[:quizcode_length])
  end

  def generate_unique_code(code_name, length)
    loop do
      unique_code = generate_code(length)
      quiz = Quiz.find_by(code_name.to_sym => unique_code)
      if quiz.nil?
        return unique_code
      end
    end
  end

  def generate_code(length)
    SecureRandom.urlsafe_base64((3 * length)/4)
  end

  #FIXME_AB: It should be after commit
  def set_attemptable_status question
    update_attributes(attemptable: (questions.length == number_of_questions))
  end

  def check_maximum_questions_limit question
    if questions.length + 1 > number_of_questions
      errors.add(:questions, "Cannot have more than #{ number_of_questions } questions")
      raise ActiveRecord::Rollback
    end
  end

  def check_assigned_questions_length
    if questions.length > number_of_questions
      errors.add(:assigned_questions, "Cannot be more than maximum questions")
    end
  end

  def add_marks question
    update_attributes(marks: (marks + question.points))
  end

  def subtract_marks question
    update_attributes(marks: (marks - question.points))
  end

  def set_quiz_attemptable_status
    self.attemptable = questions.length == number_of_questions
    true
  end

  def valid_timing?
    current_date_time = DateTime.current
    (current_date_time > start_date_time) && (current_date_time < (end_date_time + duration.seconds))
  end
end
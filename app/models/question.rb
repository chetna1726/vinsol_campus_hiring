class Question < ActiveRecord::Base

  TYPES = ['MCQ', 'Subjective']
  
  paginates_per QUESTION[:per_page]

  has_and_belongs_to_many :quizzes
  has_many :options, inverse_of: :question, dependent: :destroy
  has_many :responses

  has_attached_file :image, styles: { medium: "500x500" }

  belongs_to :category, inverse_of: :questions, counter_cache: true
  belongs_to :difficulty_level, inverse_of: :questions, counter_cache: true
  belongs_to :admin

  acts_as_taggable
  acts_as_taggable_on :tags

  before_destroy :if_quizzes_present?
  after_save ThinkingSphinx::RealTime.callback_for(:question)

  validates :content, :points, :category, :difficulty_level, :status, presence: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, if: 'points.present?'
  validates :content, uniqueness: { case_sensitive: false }, if: 'content.present?'
  validates :type, inclusion: { in: TYPES,
    message: "%{value} is not a valid question type" }
  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/png"] }, size: { in: 0..1.megabytes }

  accepts_nested_attributes_for :options, allow_destroy: true

  delegate :name, :parent, :parent_name, to: :category, prefix: true, allow_nil: true
  delegate :name, to: :difficulty_level, prefix: true, allow_nil: true
  delegate :answers, to: :options, allow_nil: true
  delegate :name, :email, to: :admin, prefix: true, allow_nil: true

  before_save :destroy_image

  def image_delete
    @image_delete ||= "0"
  end

  def image_delete=(value)
    @image_delete = value
  end

  def hit_ratio
    total_hits > 0 ? "#{ (Float(successful_hits * 100)/total_hits).round(2) }%" : nil
  end
  
  private

  def if_quizzes_present?
    quizzes.size.zero?
  end

  def destroy_image
    self.image.clear if @image_delete == "1"
  end

end

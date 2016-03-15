class Category < ActiveRecord::Base

  paginates_per CATEGORY[:per_page]

  auto_strip_attributes :name, squish: true

  belongs_to :parent, class_name: 'Category'
  has_many :category_questions, through: :sub_categories, source: :questions
  has_many :sub_categories, class_name: 'Category', foreign_key: "parent_id", dependent: :restrict_with_exception
  has_many :questions, inverse_of: :category, dependent: :restrict_with_exception

  after_save ThinkingSphinx::RealTime.callback_for(:question, [:questions])

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
  validate :cannot_be_parent_of_self, on: :update
  validate :cannot_make_it_parent
  
  delegate :name, to: :parent, prefix: true, allow_nil: true
  
  scope :root, -> { joins(:sub_categories).uniq }
  scope :root_all, -> { where(parent_id: nil) }

  private

  def cannot_be_parent_of_self
    if parent_id == id
      errors.add(:invalid_parent, "Cannot be one's own parent")
    end
  end

  def cannot_make_it_parent
    if questions.exists? && parent_id.nil?
      errors.add(:category, 'cannot be made a parent')
    end
  end

end
class DifficultyLevel < ActiveRecord::Base
  
  auto_strip_attributes :name, squish: true

  has_many :questions, inverse_of: :difficulty_level, dependent: :restrict_with_exception

  after_save ThinkingSphinx::RealTime.callback_for(:question, [:questions])

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }

end

class Option < ActiveRecord::Base

  auto_strip_attributes :value, squish: true

  belongs_to :question, inverse_of: :options

  validates :value, :question, presence: true

  scope :answers, -> { where answer: true }

end

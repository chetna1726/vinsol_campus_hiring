require 'spec_helper'

describe Question do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:points) }
    it { should validate_presence_of(:status) }
    it { ensure_inclusion_of(:type).in_array(Question::TYPES) }
    it do 
      should validate_numericality_of(:points)
      .only_integer
      .is_greater_than_or_equal_to(1)
    end

    context 'associations' do 
      it { should belong_to(:category) }
      it { should belong_to(:difficulty_level) }
      it { should have_many(:options).dependent(:destroy) }
      it { should have_many(:responses) }
      it { should have_and_belong_to_many(:quizzes) }
      it { should accept_nested_attributes_for(:options).allow_destroy(true) }
      it { should have_attached_file(:image) }
      it { should validate_attachment_content_type(:image).allowing('image/png', 'image/gif', 'image/jpeg', 'image/jpg') }
      it { should validate_attachment_size(:image).in(0..1.megabytes) }
    end

  end
end

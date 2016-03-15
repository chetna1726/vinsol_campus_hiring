class AddColumnAnswerDescriptionToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answer_description, :text, limit: nil
  end
end

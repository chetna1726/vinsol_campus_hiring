class AddIndexToQuestionsQuizzes < ActiveRecord::Migration
  def change
    add_index :questions_quizzes, :question_id
    add_index :questions_quizzes, :quiz_id
  end
end

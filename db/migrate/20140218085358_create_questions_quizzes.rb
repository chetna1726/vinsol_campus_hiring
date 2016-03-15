class CreateQuestionsQuizzes < ActiveRecord::Migration
  def change
    create_table :questions_quizzes, id: false do |t|
      t.integer :question_id, :quiz_id
    end
  end
end

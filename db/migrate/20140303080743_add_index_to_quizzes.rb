class AddIndexToQuizzes < ActiveRecord::Migration
  def change
    add_index :quizzes, :code
  end
end

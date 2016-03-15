class RenameTableUserQuizzes < ActiveRecord::Migration
  def change
    rename_table :user_quizzes, :assigned_quizzes
  end
end

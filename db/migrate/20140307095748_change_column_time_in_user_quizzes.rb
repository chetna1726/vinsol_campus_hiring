class ChangeColumnTimeInUserQuizzes < ActiveRecord::Migration
  def up
    remove_column :user_quizzes, :time
    add_column :user_quizzes, :time, :integer, default: 0
  end

  def down
    remove_column :user_quizzes, :time
    add_column :user_quizzes, :time, :time
  end
end

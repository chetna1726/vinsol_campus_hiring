class ChangeColumnDurationInQuizzes < ActiveRecord::Migration
  def up
    remove_column :quizzes, :duration
    add_column :quizzes, :duration, :integer, default: 0
  end

  def down
    remove_column :quizzes, :duration
    add_column :quizzes, :duration, :time
  end
end

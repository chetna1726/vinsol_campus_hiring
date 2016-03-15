class AddColumnToAssignedQuizzes < ActiveRecord::Migration
  def change
    add_column :assigned_quizzes, :number_of_attempts, :integer, default: 0
  end
end

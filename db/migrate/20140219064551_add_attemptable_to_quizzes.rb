class AddAttemptableToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :attemptable, :boolean, default: false
  end
end

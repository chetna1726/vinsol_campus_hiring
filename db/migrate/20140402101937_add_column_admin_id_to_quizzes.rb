class AddColumnAdminIdToQuizzes < ActiveRecord::Migration
  def change
    add_reference :quizzes, :admin, index: true
  end
end

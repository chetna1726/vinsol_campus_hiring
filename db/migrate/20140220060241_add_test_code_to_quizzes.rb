class AddTestCodeToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :code, :string
  end
end

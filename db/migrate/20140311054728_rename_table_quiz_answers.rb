class RenameTableQuizAnswers < ActiveRecord::Migration
  def change
    rename_table :quiz_answers, :responses
  end
end

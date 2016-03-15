class CreateQuizAnswers < ActiveRecord::Migration
  def change
    create_table :quiz_answers do |t|
      t.references :user, :question, :option, :quiz
      t.string :answer
      t.boolean :attempted, default: false
      t.timestamps
    end
  end
end

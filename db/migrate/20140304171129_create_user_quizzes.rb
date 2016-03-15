class CreateUserQuizzes < ActiveRecord::Migration
  def change
    create_table :user_quizzes do |t|
      t.time :time
      t.decimal :score, precision: 12, scale: 2
      t.references :user, index: true
      t.references :quiz, index: true
      t.boolean :attempted, default: false 
      t.timestamps
    end
  end
end

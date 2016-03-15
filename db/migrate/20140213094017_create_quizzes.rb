class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name, :passcode
      t.text :instructions
      t.timestamp :start_date_time, :end_date_time
      t.time :duration
      t.decimal :negative_marking, precision: 5, default: 0
      t.boolean :shuffle_questions, :shuffle_options
      t.integer :number_of_questions
      t.timestamps
      t.index :passcode
    end
  end
end

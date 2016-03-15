class AddColumnToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :marks, :integer, default: 0
    Quiz.all.each do |t|
      t.update_attributes(marks: t.questions.map(&:points).inject(&:+))
    end
  end
end

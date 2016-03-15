class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :type
      t.text :content
      t.belongs_to :category
      t.belongs_to :difficulty_level
      t.string :status
      t.integer :points
      t.decimal :success_rate, default: 0, precision:5, scale: 2
      t.timestamps
    end
  end
end

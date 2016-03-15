class AddIndexes < ActiveRecord::Migration
  def change
    add_index :categories, :parent_id
    add_index :options, :question_id
    add_index :questions, :category_id
    add_index :questions, :difficulty_level_id
  end
end

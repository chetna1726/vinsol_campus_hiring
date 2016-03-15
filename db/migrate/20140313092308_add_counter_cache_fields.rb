class AddCounterCacheFields < ActiveRecord::Migration
   def self.up
    add_column :categories, :questions_count, :integer, default: 0
    Category.find_each do |c|
      Category.reset_counters c.id, :questions
    end
    add_column :difficulty_levels, :questions_count, :integer, default: 0
    DifficultyLevel.find_each do |d|
      DifficultyLevel.reset_counters d.id, :questions
    end
  end

  def self.down
    remove_column :categories, :questions_count
    remove_column :difficulty_levels, :questions_count
  end
end

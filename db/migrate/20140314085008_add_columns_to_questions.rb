class AddColumnsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :successful_hits, :integer, default: 0
    add_column :questions, :total_hits, :integer, default: 0
  end
end

class ChangeColumnDefaultPointsInQuestions < ActiveRecord::Migration
  def up
    change_column :questions, :points, :integer, default: 1
  end

  def down
    change_column :questions, :points, :integer
  end
end

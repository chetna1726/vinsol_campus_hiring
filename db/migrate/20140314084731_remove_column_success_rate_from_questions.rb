class RemoveColumnSuccessRateFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :success_rate
  end
end

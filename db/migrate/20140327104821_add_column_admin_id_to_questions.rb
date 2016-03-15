class AddColumnAdminIdToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :admin, index: true
  end
end

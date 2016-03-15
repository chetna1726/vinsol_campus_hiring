class AddColumnCorrectToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :correct, :boolean, default: false
  end
end

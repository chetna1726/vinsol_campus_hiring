class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :contact_number, :string
    add_column :users, :college_name, :string
    add_column :users, :enrollment_number, :string
    add_column :users, :engineering_branch, :string
  end
end

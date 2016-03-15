class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.text :value
      t.belongs_to :question
      t.boolean :answer
      t.timestamps
    end
  end
end

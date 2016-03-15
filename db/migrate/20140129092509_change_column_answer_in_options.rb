class ChangeColumnAnswerInOptions < ActiveRecord::Migration
  def up
    change_column :options, :answer, :boolean, default: false
    Option.all.each do |o|
      if o.answer.nil?
        o.update_attribute('answer', false)
      end 
    end
  end

  def down
    change_column :options, :answer, :boolean, default: nil
    Option.all.each do |o|
      if o.answer == false
        o.update_attribute('answer', nil)
      end 
    end
  end
end

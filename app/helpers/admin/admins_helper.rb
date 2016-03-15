module Admin::AdminsHelper

  def root_categories
    Category.root
  end

  def categories
    Category.all
  end

  def difficulty_levels
    DifficultyLevel.all
  end

  def sub_categories
    (categories - Category.root_all).to_json(only: [:id, :name, :parent_id])
  end
  
end

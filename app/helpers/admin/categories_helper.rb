module Admin::CategoriesHelper

  def parent_category(category)
    category.parent.try(:name)
  end

  def questions(category)
    (category.parent ? category.questions : category.category_questions).page(params[:page])
  end
end

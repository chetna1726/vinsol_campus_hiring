module Admin::QuizzesHelper
  def display_error_messages(fetched)
    if fetched
      error_string = ((fetched == 0) ? "This selection did not fetch any questions" : "This selection fetched only #{ fetched } questions")
    end
  end
end

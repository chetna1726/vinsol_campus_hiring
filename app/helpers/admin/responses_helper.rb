module Admin::ResponsesHelper
  def highlight(response)
    response.correct? ? '' : 'highlight'
  end

  def correct_or_incorrect(response)
    response.correct? ? 'Correct' : 'Incorrect'
  end
end

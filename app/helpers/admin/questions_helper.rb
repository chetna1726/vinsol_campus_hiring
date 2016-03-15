module Admin::QuestionsHelper

  def render_question_partial(question_type, builder)
    render partial: "admin/#{ question_type.downcase }s/options", locals: { f: builder }
  end

  def render_option_field_partial(question_type, builder)
    render partial: "admin/#{ question_type.downcase }s/option_fields", locals: { f: builder }
  end

  def selected_category(question)
    question.category.try(:parent_id)
  end

  def subcategories(question)
    question.category ? question.category_parent.sub_categories : []
  end

  def render_partial_show(question_type)
    render partial: "admin/#{ question_type.downcase }s/show"
  end

  def render_options(question)
    if question.type == 'MCQ'
      render partial: 'admin/questions/list', locals: { items: question.options }
    end
  end

  def set_image_name(question, builder)
    if question.image_file_name
      str = "<div>
        #{ question.image_file_name }
        <br>
        #{ builder.hidden_field :image_delete }
        #{ link_to 'Remove', 'javascript:;', class: 'remove_image' }
      </div>
      #{ builder.file_field :image, class: 'hide' }"
      str.html_safe
    else
      str = builder.file_field :image
    end
  end
end

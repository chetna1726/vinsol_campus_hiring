ThinkingSphinx::Index.define :question, :with => :active_record do
  # fields
  indexes content, sortable: true
  indexes options.value, as: :option_value
  indexes category.name, as: :category, sortable: true
  indexes category.parent.name, as: :parent_category, sortable: true
  indexes difficulty_level.name, as: :difficulty_level

  # attributes
end
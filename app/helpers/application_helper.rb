module ApplicationHelper
  def link_to_remove (name)
    link_to name, 'javascript:;', class: 'remove_fields'
  end
  
  def add_fields(name, f, association, type)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render partial: ("admin/" + type + "s/" + association.to_s.singularize + "_fields"), locals: { f: builder }
    end
    link_to name,'javascript:;', { data: { association: "#{ association }", fields: "#{ fields }" } , class: 'add_fields' }
  end

  def image_for(object, size = nil)
    if object.image.file?
      image_tag object.image.url(size)
    end
  end

  def pagination_header(object)
    if object
      "Showing #{ object.offset_value + 1 } - #{ object.offset_value + object.length } of #{ object.total_count }"
    end
  end
end

module FormTemplateColumnsHelper
  def form_field_for_column(column)
    field_type = column.field_type.present? ? column.field_type : calculate_field_type_from_column(column)
    # Do this to be sure we pass the right variables to the right form option method
    form_field = case field_type.to_s
    when /collection_select/i
      send(field_type, object_name, column.name, column.name.gsub(/_id/,'').classify.constantize.all, :id, :name)
    when /select/i
      # TODO: make this flexible and add some documentation
      send(field_type, object_name, column.name, column.field_options.split(',').map(&:strip))
    when /text_field|text_area|date|datetime_select|check_box/i
      send(field_type, object_name, column.name)
    end
  end

  def object_name
    @object_name ||= @form_template.owner_type.tableize.singularize.to_sym
  end

protected
  def calculate_field_type_from_column(column)
    case column.sql_type.to_s
    when /integer|float|decimal|string|char|binary/i
      column.name =~ /_id/ ? :collection_select : :text_field
    when /clob|text/i
      :text_area
    when /boolean/i
      :check_box
    when /datetime/i
      :datetime_select
    when /date/
      :date_select
    end
  end
end
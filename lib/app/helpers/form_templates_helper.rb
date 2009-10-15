# TODO: Refactor the build_form_template_columns_for method
module FormTemplatesHelper
  def build_form_template_columns_for(klass)
    # figure out what class we're dealing with here and load it
    klass = klass.is_a?(String) ? klass.classify.constantize : klass

    # store the existing form_template_column_names in a local variable for quick reference
    existing_form_template_column_names = @form_template.form_template_columns.map(&:name)

    # store possible template_columns in a local variable for quick reference
    possible_form_template_column_names = klass.template_columns.map(&:name)

    @form_template_columns ||= returning @form_template.form_template_columns do |form_template_columns|
      # don't display #form_template.form_template_columns unless they're possible template_columns for the given class
      form_template_columns.delete_if do |form_template_column|
        !possible_form_template_column_names.include?(form_template_column.name)
      end

      # what's left should be selected
      form_template_columns.collect { |form_template_column| form_template_column.selected = true }

      # this will loop through Model#template_columns and instantiate a new FormTemplateColumn record for each that isn't already
      # included in the the current form template's template columns
      klass.template_columns.each do |template_column|
        # If this is already a form_template_column object, skip it
        next if existing_form_template_column_names.include?(template_column.name)

        # Not sure why, but @form_template.form_template_columns.build was tossing two new objects into the array instead of one
        @form_template.form_template_columns.build(:name => template_column.name, :sql_type => template_column.type.to_s)
      end
    end
  end

  def fields_for_form_template_column(form_template_column, &block)
    prefix = form_template_column.new_record? ? 'new' : 'existing'
    fields_for("form_template[#{prefix}_form_template_column][]", form_template_column, &block)
  end

  def render_form_template_fields
    render :partial => 'partials/form_template_columns'
  end

  def templatable_models
    @templatable_models ||= find_templatable_models
  end

protected
  def find_templatable_models
    # get rid of any '.' or '..'
    model_files = Dir.entries(File.join(RAILS_ROOT, 'app', 'models')).delete_if { |file_name| file_name =~ /^\.+/ }
    model_files.inject([]) do |array, model_file|
      # constantize the string
      klass = model_file.gsub(/\.rb/,'').classify.constantize
      # add it to the array if it's templatable
      array << klass.class_name if klass.templatable?
      array
    end
  end
end
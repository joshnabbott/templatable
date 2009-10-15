class FormTemplate < ActiveRecord::Base
  has_many :form_template_columns, :dependent => :destroy
  has_many :styles, :dependent => :nullify
  validates_presence_of :name, :owner_type
  validates_uniqueness_of :name, :scope => :owner_type, :allow_nil => true
  after_update :save_form_template_columns

  named_scope :for_owner_type, lambda { |owner_type| { :conditions => { :owner_type => owner_type } } }

  def new_form_template_column=(form_template_column_attributes)
    form_template_column_attributes.each do |attributes|
      case attributes && attributes.delete(:selected).to_i
      when 1
        form_template_columns.build(attributes)
      end
    end
  end

  def existing_form_template_column=(form_template_column_attributes)
    form_template_columns.each do |form_template_column|
      attributes = form_template_column_attributes[form_template_column.id.to_s]
      case attributes && attributes.delete(:selected).to_i
      when 1
        form_template_column.attributes = attributes
      else
        form_template_column.destroy
      end
    end
  end

protected
  def save_form_template_columns
    self.form_template_columns.map(&:save!)
  end
end
class FormTemplateColumn < ActiveRecord::Base
  FIELD_TYPES = [[''], ['Select','select']]

  serialize :options
  attr_accessor :selected
  acts_as_list :scope => :form_template_id
  before_save :set_options
  default_scope :order => 'position asc'
  belongs_to :form_template
  validates_presence_of :name, :sql_type
  validates_presence_of :field_options, :if => Proc.new { |record| record.field_type == 'select' }

  def human_name
    ActiveRecord::Base.human_attribute_name(name)
  end

  def after_initialize
    self.options ||= { 'field_type' => nil, 'field_options' => nil }
  end

  def field_options
    @field_options ||= options['field_options']
  end

  def field_options=(value)
    @field_options = value
  end

  def field_type
    @field_type ||= options['field_type']
  end

  def field_type=(value)
    @field_type = value
  end

  def set_options
    self.options = { 'field_type' => self.field_type, 'field_options' => self.field_options }
  end
end
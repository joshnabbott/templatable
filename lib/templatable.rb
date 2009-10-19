module Templatable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Every ActiveRecord::Base model should have a class method `templatable?` and it should return false for now
    def templatable?
      false
    end

    def templatable(&block)
      # Declare associations, include instance methods, ensure template columns that need to be validated are validated.
      self.class_eval <<-EOV
        include Templatable::InstanceMethods
        belongs_to :form_template
        has_many :form_template_columns, :through => :form_template
        before_validation :set_validators_for_form_template_columns
      EOV

      Array.class_eval do
        def add(model_name, *column_names_to_be_included)
          klass   = model_name.to_s.classify.constantize
          columns = klass.columns.dup
          columns = columns.delete_if { |column| !column_names_to_be_included.include?(column.name.to_sym) }
          self.concat(columns)
        end

        def exclude(*column_names_to_be_excluded)
          self.delete_if { |column| column_names_to_be_excluded.include?(column.name.to_sym) }
        end
      end

      # Add these methods to the ActiveRecord Model
      self.instance_eval do
        # This model is templatable
        def templatable?
          true
        end

        def template_columns
          # dup Class#columns so we're not modifying the actual columns array that the db uses.
          @template_columns ||= columns.dup
        end

        protected
          def excluded_template_columns
            @excluded_template_columns
          end

          def excluded_template_columns=(*column_names)
            @excluded_template_columns = column_names.flatten
          end
      end

      block.call(self)
    end
  end

  module InstanceMethods
    def set_validators_for_form_template_columns
      self.form_template_columns.each do |form_template_column|
        self.class.instance_eval { validates_presence_of :"#{form_template_column.name}" } if form_template_column.field_required
      end
    end
  end
end
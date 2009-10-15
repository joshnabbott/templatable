require 'templatable'
ActiveRecord::Base.instance_eval { include Templatable }

# Controllers
require 'app/controllers/form_templates_controller'

# Models
require 'app/models/form_template'
require 'app/models/form_template_column'

# Helpers
require 'app/helpers/form_templates_helper'
require 'app/helpers/form_template_columns_helper'
ActionView::Base.instance_eval { include FormTemplatesHelper }
ActionView::Base.instance_eval { include FormTemplateColumnsHelper }

# Add plugin's views to view paths
ActionController::Base.append_view_path(File.join(File.dirname(__FILE__), 'lib', 'app', 'views'))
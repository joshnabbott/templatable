class TemplatableMigration < ActiveRecord::Migration
  def self.up
    create_table :form_templates do |t|
      t.string :owner_type, :name, :null => false
      t.timestamps
    end
    add_index :form_templates, :owner_type

    create_table :form_template_columns do |t|
      t.belongs_to :form_template
      t.string :name, :sql_type
      t.text :options
      t.integer :position
      t.timestamps
    end
    add_index :form_template_columns, :form_template_id
  end

  def self.down
    drop_table :form_templates
    drop_table :form_template_columns
  end
end
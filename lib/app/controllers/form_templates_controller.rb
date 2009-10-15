class FormTemplatesController < ApplicationController
  # GET /form_templates
  # GET /form_templates.xml
  def index
    @form_templates = FormTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @form_templates }
    end
  end

  # GET /form_templates/new
  # GET /form_templates/new.xml
  def new
    @form_template = FormTemplate.new
    @owner_type    = set_owner_type

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form_template }
      format.js do
        render :update do |page|
          page.replace_html :form_template_columns, :partial => 'form_template_columns', :locals => { :form_template_columns => build_form_template_columns_for(@owner_type) }
        end
      end
    end
  end

  # GET /form_templates/1/edit
  def edit
    @form_template = FormTemplate.find(params[:id])
    @owner_type    = set_owner_type

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form_template }
      format.js do
        render :update do |page|
          page.replace_html :form_template_columns, :partial => 'form_template_columns', :locals => { :form_template_columns => build_form_template_columns_for(@owner_type) }
        end
      end
    end
  end

  # POST /form_templates
  # POST /form_templates.xml
  def create
    @form_template = FormTemplate.new(params[:form_template])

    respond_to do |format|
      if @form_template.save
        flash[:success] = 'Form template was successfully created.'
        format.html { redirect_to(form_templates_url) }
        format.xml  { render :xml => @form_template, :status => :created, :location => @form_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @form_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /form_templates/1
  # PUT /form_templates/1.xml
  def update
    @form_template = FormTemplate.find(params[:id])

    respond_to do |format|
      if @form_template.update_attributes(params[:form_template])
        flash[:success] = 'Form template was successfully updated.'
        format.html { redirect_to(form_templates_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @form_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /form_templates/1
  # DELETE /form_templates/1.xml
  def destroy
    @form_template = FormTemplate.find(params[:id])
    @form_template.destroy

    respond_to do |format|
      flash[:success] = 'Form template was successfully deleted.'
      format.html { redirect_to(form_templates_url) }
      format.xml  { head :ok }
    end
  end

protected
  def set_owner_type
    @owner_type = case @form_template.new_record?
    when true
      params[:form_template] ? params[:form_template][:owner_type] : 'Style'
    else
      params[:form_template] ? params[:form_template][:owner_type] : @form_template.owner_type
    end
  end
end
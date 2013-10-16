class ProjectController < ApplicationController
  before_filter :load_project
  before_filter :ensure_project_id, only: [:update, :create]
  before_filter :check_layout
  before_filter :init_options

  layout "entries"

  def load_project
    @project = Project.find(params[:project_id])
  end

  def check_layout
    @layout = (params[:layout] == "true")
  end

  def init_options
    @options = {}
    @options[:render_as_partial] = (params[:render_as_partial] == "true")
    @options[:layout] = (params[:layout] == "true")
    # @options[:quiet] = (params[:quiet]) ? (params[:quiet] == "true") : true
    @options[:quiet] = (params[:quiet] == "true")
  end
end

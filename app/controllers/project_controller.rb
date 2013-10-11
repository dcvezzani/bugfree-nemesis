class ProjectController < ApplicationController
  before_filter :load_project
  before_filter :ensure_project_id, only: [:update, :create]
  layout "entries"

  def load_project
    @project = Project.find(params[:project_id])
  end
end

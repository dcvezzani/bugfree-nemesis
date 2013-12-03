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
    @options[:stand_alone] = (params[:stand_alone]) ? (params[:stand_alone] == "true") : false

    @options
  end

  def load_latest_entry(story)
    @latest_entry = if(story.entries.length > 0)
      story.entries.last
      
    else
      todays_entry = Entry.where{ recorded_for == my{Time.zone.now.to_date} }.first

      if(!todays_entry)
        todays_entry = Entry.create!(recorded_for: Time.zone.now, title: "Adjust hours worked on story", project: @project)
      end

      todays_entry
    end
  end

  def load_subject
    @subject = (params[:subject] or "entry")
  end
end

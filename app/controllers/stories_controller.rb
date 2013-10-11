class StoriesController < ProjectController
  before_filter :ensure_project_id, only: [:update, :create, :update_hours]

  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.where{project_id == my{@project.id}}.order{[due_on.asc, updated_at.desc]}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stories }
    end
  end

  def list
    @stories = Story.where{project_id == my{@project.id}}.order{[due_on.asc, updated_at.desc]}
    @associated_stories = AssociatedStories.new

    respond_to do |format|
      format.html { render partial: 'list' }
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.json
  def new
    @story = Story.new(project_id: @project.id, due_on: Date.today + 7)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(params[:story])

    respond_to do |format|
      if @story.save
        format.html { redirect_to [@project, @story], notice: 'Story was successfully created.' }
        format.json { render json: @story, status: :created, location: @story }
      else
        format.html { render action: "new" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to [@project, @story], notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_hours
    @story = Story.find(params[:id])
    no_errors = true
    status = 200
    notice = nil

    if @story.same_attribute_values?(params[:story]) 
      status = 304

    else
      no_errors = @story.update_attributes(params[:story])

      if(no_errors)
        notice = "Hours for story were successfully updated: (e: #{@story.hours_est}, w: #{@story.hours_worked}, t: #{@story.hours_todo})"
      else
        notice = "Hours were not updated for some reason."
      end
    end

    respond_to do |format|
      if no_errors 
        format.html { redirect_to [@project, @story], notice: notice }
        format.json { render json: {msg: notice}, status: status }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def mark_as_done
    @story = Story.find(params[:id])

    respond_to do |format|
      # if @story.update_attributes(params[:story])
      if @story.close
        format.html { redirect_to [@project, :stories], notice: 'Story was successfully marked as closed.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to [@project, :stories] }
      format.json { head :no_content }
    end
  end

  def ensure_project_id
    params[:story][:project_id] = @project.id unless params[:story].has_key?(:project_id)
  end
end

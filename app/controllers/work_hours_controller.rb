class WorkHoursController < ProjectController
  before_filter :load_entry
  before_filter :load_story

  before_filter :load_subject, only: [:new, :destroy]

  # GET /work_hours
  # GET /work_hours.json
  def index
    @work_hours = WorkHour.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_hours }
    end
  end

  # GET /work_hours/1
  # GET /work_hours/1.json
  def show
    @work_hour = WorkHour.find(params[:id])

    respond_to do |format|
      format.html { render action: 'show', layout: @options[:layout] }
      format.json { render json: @work_hour }
    end
  end

  # GET /work_hours/new
  # GET /work_hours/new.json
  def new
    @work_hour = WorkHour.new
    @options.merge!({url: [@project, @entry, @story, :add_hours_worked]})

    respond_to do |format|
      format.html { render action: 'new', layout: @options[:layout] }
      format.json { render json: @work_hour }
    end
  end

  # GET /work_hours/1/edit
  def edit
    @work_hour = WorkHour.find(params[:id])
    @options.merge!({url: [@project, @entry, @story, @work_hour]})

    respond_to do |format|
      format.html { render action: 'edit', layout: @options[:layout] }
      format.json { render json: @work_hour }
    end
  end

  # POST /work_hours
  # POST /work_hours.json
  def create
    @work_hour = WorkHour.new(params[:work_hour])

    respond_to do |format|
      if @work_hour.save
        format.html { redirect_to @work_hour, notice: 'Work hour was successfully created.' }
        format.json { render json: @work_hour, status: :created, location: @work_hour }
      else
        format.html { render action: "new" }
        format.json { render json: @work_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /work_hours/1
  # PUT /work_hours/1.json
  def update
    @work_hour = WorkHour.find(params[:id])

    respond_to do |format|
      if @work_hour.update_attributes(params[:work_hour])
        format.html { redirect_to @work_hour, notice: 'Work hour was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @work_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_hours/1
  # DELETE /work_hours/1.json
  def destroy
    @work_hour = WorkHour.find(params[:id])
    entry_story = @work_hour.entry_stories.last


    respond_to do |format|
      if(entry_story.remove_hours_worked!(@work_hour) and @story.reload)
        notice = "#{WorkHour.name} was successfully removed."

        format.html { 
          if(@subject == "story")
            entry_story.story.reload
            load_latest_entry(entry_story.story)
            render partial: 'stories/story_work_hours', locals: { story: entry_story.story, status: "show-details" }
        
          else
            redirect_to [@project, @entry, @story, :work_hours], notice: notice 
          end
        }
        format.json { render json: {msg: notice} }

      else
        alert = "Unable to remove #{WorkHour.name}."

        format.html { redirect_to [@project, @entry, @story, :work_hours], alert: alert }
        format.json { head :no_content }
      end
    end
  end

  def load_entry
    @entry = Entry.find(params[:entry_id]) if params[:entry_id]
  end
  def load_story
    @story = Story.find(params[:story_id]) if params[:story_id]
  end
end

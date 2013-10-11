class WorkIntervalsController < ProjectController
  before_filter :load_entry

  # GET /work_intervals
  # GET /work_intervals.json
  def index
    @work_intervals = WorkInterval.where{project_id == my{@project.id}}.where{entry_id == my{@entry.id}}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_intervals }
    end
  end

  # GET /work_intervals/1
  # GET /work_intervals/1.json
  def show
    @work_interval = WorkInterval.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @work_interval }
    end
  end

  # GET /work_intervals/new
  # GET /work_intervals/new.json
  def new
    @work_interval = WorkInterval.new(project_id: @project.id, entry_id: @entry_id)
    @url = [@project, @entry, :work_intervals]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @work_interval }
    end
  end

  # GET /work_intervals/1/edit
  def edit
    @work_interval = WorkInterval.find(params[:id])
    @url = [@project, @entry, @work_interval]
  end

  # POST /work_intervals
  # POST /work_intervals.json
  def create
    @work_interval = WorkInterval.new(params[:work_interval])
    @url = [@project, @entry, :work_intervals]

    respond_to do |format|
      if @work_interval.save
        format.html { redirect_to [@project, @entry, @work_interval], notice: 'Work interval was successfully created.' }
        format.json { render json: @work_interval, status: :created, location: @work_interval }
      else
        format.html { render action: "new" }
        format.json { render json: @work_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /work_intervals/1
  # PUT /work_intervals/1.json
  def update
    @work_interval = WorkInterval.find(params[:id])
    @url = [@project, @entry, @work_interval]

    updated = @work_interval.update_times(params[:work_interval])

    respond_to do |format|
      if updated
        format.html { redirect_to [@project, @entry, @work_interval], notice: 'Work interval was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @work_interval.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_intervals/1
  # DELETE /work_intervals/1.json
  def destroy
    @work_interval = WorkInterval.find(params[:id])
    @work_interval.destroy

    respond_to do |format|
      format.html { redirect_to [@project, @entry, :work_intervals] }
      format.json { head :no_content }
    end
  end

  def load_entry
    @entry = Entry.find(params[:entry_id])
  end

  def ensure_project_id
    params[:work_interval][:project_id] = @project.id unless params[:work_interval].has_key?(:project_id)
  end
end

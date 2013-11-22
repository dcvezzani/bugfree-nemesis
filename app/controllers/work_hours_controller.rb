class WorkHoursController < ApplicationController
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
      format.html # show.html.erb
      format.json { render json: @work_hour }
    end
  end

  # GET /work_hours/new
  # GET /work_hours/new.json
  def new
    @work_hour = WorkHour.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @work_hour }
    end
  end

  # GET /work_hours/1/edit
  def edit
    @work_hour = WorkHour.find(params[:id])
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
    @work_hour.destroy

    respond_to do |format|
      format.html { redirect_to work_hours_url }
      format.json { head :no_content }
    end
  end
end

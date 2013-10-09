class EntriesController < ApplicationController
  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  def copy_from_yesterday
    recorded_for_raw = "2013-10-09"
    recorded_for_raw = params[:recorded_for]

    if(recorded_for_raw.match(/^\d{4}-\d{2}-\d{2}$/))
      recorded_for_val = Date.strptime(recorded_for_raw, "%Y-%m-%d")
      previous_entries = Entry.where{recorded_for < my{recorded_for_val}}.order{recorded_for.desc}.limit(1)

      previous_entry = nil
      if(previous_entries and previous_entries.length > 0)
        previous_entry = previous_entries.first
      end

      respond_to do |format|
        format.html { render partial: 'yesterdays_log_and_related_stories', locals: {entry: previous_entry} }
        format.json { render json: @entry }
      end

    else
      respond_to do |format|
        format.html { render text: "", status: 412 }
        format.json { render json: @entry }
      end
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new(recorded_for: Date.today)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(params[:entry])

    saved = false
    begin
      Entry.transaction do
        if(@entry.save)
          update_related_stories(:yesterday, @entry, params[:yesterdays_related_stories_ids])
          update_related_stories(:today, @entry, params[:todays_related_stories_ids])
          update_related_stories(:show_stopper, @entry, params[:show_stopper_related_stories_ids])
          saved = true
        end
      end

    rescue Exception => e
      Rails.logger.warn "Unable to save entry and related stories: #{e.message}"
      Rails.logger.debug e.backtrace
    end

    respond_to do |format|
      # if @entry.save
      if saved
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    @entry = Entry.find(params[:id])

    saved = false
    begin
      Entry.transaction do
        @entry.update_attributes(params[:entry])
        update_related_stories(:yesterday, @entry, params[:yesterdays_related_stories_ids])
        update_related_stories(:today, @entry, params[:todays_related_stories_ids])
        update_related_stories(:show_stopper, @entry, params[:show_stopper_related_stories_ids])
      end
      saved = true

    rescue Exception => e
      Rails.logger.warn "Unable to save entry and related stories: #{e.message}"
      Rails.logger.debug e.backtrace
    end

    respond_to do |format|
      # if @entry.update_attributes(params[:entry])
      if saved
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url }
      format.json { head :no_content }
    end
  end

private
  def update_related_stories(category, entry, story_ids)
    return false if(story_ids.blank?)

    klass = case(category)
    when :yesterday
      entry.yesterdays_stories.destroy_all
      YesterdayEntryStory
    when :today
      entry.todays_stories.destroy_all
      TodayEntryStory
    when :show_stopper
      entry.show_stopper_stories.destroy_all
      ShowStopperEntryStory
    else
      raise "unsupported category for #update_related_stories: " + category.inspect
    end

    story_ids.each do |story_id|
      klass.create!(entry_id: entry.id, story_id: story_id)
    end
  end
end

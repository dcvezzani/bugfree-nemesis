class NotesController < ProjectController
  before_filter :load_item
  
  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.where{project_id == my{@project.id}}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.json
  def new
    @note = Note.new
    @options.merge!({stand_alone: false, url: [@project, @item, :notes]})

    respond_to do |format|
      format.html { render action: 'new', layout: @options[:layout] }
      format.json { render json: @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
    @options.merge!({stand_alone: false, url: [@project, @item, @note]})

    if(@options[:render_as_partial])
       # render partial: 'notes/form', locals: {project: @project, item: @item, note: @note}
       render partial: 'notes/form'
    else
      render action: 'edit', layout: @options[:layout]
    end
  end

  def edit_content
    @note = Note.find(params[:id])
    @options.merge!({stand_alone: false, url: [:update_content, @project, @item, @note]})

    if(@options[:render_as_partial])
       # render partial: 'notes/form', locals: {project: @project, item: @item, note: @note}
       render partial: 'notes/form'
    else
      render action: 'edit', layout: @options[:layout]
    end
  end

  

  # POST /notes
  # POST /notes.json
  def create
    params[:note][:project_id] = @project.id
    saved = false

    begin
      Note.transaction do
        @note = Note.create!(params[:note])
        item_note_class.create!(item_id: @item.id, note_id: @note.id)
        saved = true
      end
    rescue Exception => e
      Rails.logger.warn "note not added\n#{e.message}"
      Rails.logger.debugger e.backtrace
    end

    respond_to do |format|
      if saved
        notice = "#{Note.name} was successfully created."

        format.html { 
          if(@options[:render_as_partial])
            render partial: 'notes/show_note_log_item', locals: {project: @project, item: @item, note: @note}
          else
            redirect_to [@project, @item, @note], notice: notice 
          end
        }
        format.json { render json: {note: @note, msg: notice}, status: :created, location: [@project, @item, @note] }
      else
        format.html { render action: "new" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.json
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to [@project, @item, @note], notice: "#{Note.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_content
    @note = Note.find(params[:id])
    @note.content = params[:note][:content]

    respond_to do |format|
      if @note.save
        notice = "#{Note.name} was successfully updated."

        format.html { redirect_to [@project, @item, @note], notice: notice }
        format.json { render json: {content: @note.content, msg: notice} }
      else
        format.html { render action: "edit" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    notice = "#{Note.name} was successfully removed."

    respond_to do |format|
      format.html { redirect_to [@project, @item, :notes] }
      format.json { render json: {msg: notice} }
    end
  end

  def ensure_project_id
    params[:note][:project_id] = @project.id unless params[:note].has_key?(:project_id)
  end

  def item_note_class
    Note
  end

  def load_item
    raise "overload in inheriting class"
  end
end

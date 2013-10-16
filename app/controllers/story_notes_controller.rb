class StoryNotesController < NotesController
  def item_note_class
    StoryNote
  end

  def load_item
    @item = Story.find(params[:story_id])
  end
end


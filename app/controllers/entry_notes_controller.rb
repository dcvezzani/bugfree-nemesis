class EntryNotesController < NotesController
  def item_note_class
    EntryNote
  end

  def load_item
    @item = Entry.find(params[:entry_id])
  end
end

class ShowStopperEntryStory < EntryStory
  attr_accessible :entry_id, :story_id

  belongs_to :entry
  belongs_to :story
end

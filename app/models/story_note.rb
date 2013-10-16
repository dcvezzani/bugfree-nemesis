class StoryNote < ItemNote
  attr_accessible :item_id, :note_id

  belongs_to :story, foreign_key: :item_id
  belongs_to :note
end



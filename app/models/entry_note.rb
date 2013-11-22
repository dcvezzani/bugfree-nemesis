class EntryNote < ItemNote
  attr_accessible :item_id, :note_id

  belongs_to :entry, foreign_key: :item_id
  belongs_to :note, dependent: :destroy
end


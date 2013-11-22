class WorkHourNote < ItemNote
  attr_accessible :item_id, :note_id

  belongs_to :work_hour, foreign_key: :item_id, dependent: :destroy
  belongs_to :note, dependent: :destroy
end






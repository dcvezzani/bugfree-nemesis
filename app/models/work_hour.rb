class WorkHour < ActiveRecord::Base
  attr_accessible :hours, :note

  belongs_to :entry_story

  has_many :work_hour_notes, foreign_key: :item_id, source: :work_hour, dependent: :destroy
  has_many :notes, through: :work_hour_notes, source: :note, dependent: :destroy, order: "created_at asc"

end

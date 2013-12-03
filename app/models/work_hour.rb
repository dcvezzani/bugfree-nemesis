class WorkHour < ActiveRecord::Base
  attr_accessible :hours, :note

  has_many :story_work_hours
  has_many :stories, through: :story_work_hours

  has_many :entry_story_work_hours
  has_many :entry_stories, through: :entry_story_work_hours

  #has_many :work_hour_notes, foreign_key: :item_id, source: :work_hour, dependent: :destroy
  #has_many :notes, through: :work_hour_notes, source: :note, dependent: :destroy, order: "created_at asc"

  def entry
    (self.entry_stories.first and self.entry_stories.first.entry)
  end
end

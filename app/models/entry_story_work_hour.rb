class EntryStoryWorkHour < ActiveRecord::Base
  attr_accessible :entry_story_id, :work_hour_id

  belongs_to :entry_story
  belongs_to :work_hour
end

class StoryWorkHour < ActiveRecord::Base
  attr_accessible :story_id, :work_hour_id

  belongs_to :story
  belongs_to :work_hour
end

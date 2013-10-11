class EntryStory < ActiveRecord::Base
  attr_accessible :entry_id, :story_id, :project_id

  validates :project_id, presence: true

  belongs_to :entry
  belongs_to :story
end

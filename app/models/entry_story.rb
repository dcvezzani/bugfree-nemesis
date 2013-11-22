class EntryStory < ActiveRecord::Base
  attr_accessible :entry_id, :story_id, :project_id

  validates :project_id, presence: true

  belongs_to :project
  belongs_to :entry
  belongs_to :story

  has_many :work_hours, dependent: :destroy, order: "created_at asc"
end

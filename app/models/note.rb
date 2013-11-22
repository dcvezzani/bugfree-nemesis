class Note < ActiveRecord::Base
  attr_accessible :content, :name, :project_id

  has_many :entry_notes, foreign_key: :note_id, source: :entry
  has_many :entries, through: :entry_notes, source: :entry

  has_many :story_notes, foreign_key: :note_id, source: :story
  has_many :stories, through: :story_notes, source: :story

  has_many :work_hour_notes, foreign_key: :note_id, source: :work_hour
  has_many :work_hours, through: :work_hour_notes, source: :work_hour

  def plain_content
    content.gsub(/<[^>]+>/, "")
  end
  
end

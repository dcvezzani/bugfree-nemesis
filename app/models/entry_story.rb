class EntryStory < ActiveRecord::Base
  attr_accessible :entry_id, :story_id, :project_id

  validates :project_id, presence: true

  belongs_to :project
  belongs_to :entry
  belongs_to :story

  has_many :entry_story_work_hours
  has_many :work_hours, through: :entry_story_work_hours

  def add_hours_worked!(work_hours)
    res = false

    begin
      EntryStory.transaction do
        self.work_hours << work_hours
        self.save!

        self.story.hours_worked = self.story.work_hours_total
        self.story.save!
      end
      res = true

    rescue Exception => e
      Rails.logger.debug e.message
      # do nothing; transaction will roll back if there was a problem
    end

    return res
  end

  def remove_hours_worked!(work_hour_record)
    res = false

    begin
      EntryStory.transaction do
        work_hour_record.destroy

        self.story.hours_worked = self.story.work_hours_total
        self.story.save!
      end
      res = true

    rescue Exception => e
      Rails.logger.debug e.message
      # do nothing; transaction will roll back if there was a problem
    end

    return res
  end

  def update_hours_worked!(work_hour, work_hour_attrs)
    res = false

    begin
      EntryStory.transaction do
        raise "Unable to update EntryStory record" unless work_hour.update_attributes(work_hour_attrs)
        
        self.story.hours_worked = self.story.work_hours_total
        self.story.save!
      end
      res = true

    rescue Exception => e
      Rails.logger.debug e.message
      # do nothing; transaction will roll back if there was a problem
    end

    return res
  end
end

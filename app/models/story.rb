class Story < ActiveRecord::Base
  ACTIVE = "active"
  CLOSED = "closed"
  STATUS_VALUES = [ACTIVE, CLOSED]

  attr_accessible :description, :due_on, :hours_est, :hours_todo, :hours_worked, :stopped_since, :title, :project_id, :status, :completed_at, :project

  belongs_to :project

  has_many :entry_stories
  #has_many :entries, through: :entry_stories

  has_many :story_notes, foreign_key: :item_id, source: :story, dependent: :destroy
  has_many :notes, through: :story_notes, source: :note, dependent: :destroy, order: "created_at asc"

  # has_many :story_work_hours, dependent: :destroy
  # has_many :work_hours, through: :story_work_hours, dependent: :destroy

  validates :project_id, :status, presence: true

  scope :for_week_including, ->(_project_id, entry_date) { 
    # _project_id = 1
    # entry_date = Time.zone.now.to_date
    _start_date = entry_date.to_date.beginning_of_week
    _end_date = entry_date.to_date.end_of_week

    week_days = Entry.where{(project_id == _project_id) & (recorded_for >= _start_date) & (recorded_for <= _end_date)}; week_days.count

    _stories = Story.joins{entries}.where{entries.id.in(week_days.select{id})}.select{distinct(stories.id)}

    Story.where{id.in(_stories)}.order{[status.desc, due_on.asc, updated_at.desc]}
  }

  scope :active_stories, ->(_project_id) { where{(project_id == my{_project_id}) & (status != "closed")}.order{[due_on.asc, updated_at.desc]} }

  scope :current_completed_stories, ->(_project_id, _begin_week, _end_week) { where{(project_id == my{_project_id}) & (status == "closed") & (completed_at >= my{_begin_week}) & (completed_at <= my{_end_week})}.order{[due_on.asc, updated_at.desc]} }

  def is_open?
    status != CLOSED
  end

  def same_attribute_values?(attrs)
    self.attributes.each do |attr, value|
      if(attrs.keys.include?(attr) and attrs[attr].to_f != value)
        return false
      end
    end
    return true
  end

  def close
    # if(is_open?)
      self.status = CLOSED
      self.completed_at = Time.zone.now
      # self.hours_worked += self.hours_todo
      self.hours_todo = 0.0
      save
    # end
  end

  def work_hours
    entry_story_work_hours = EntryStory.joins{ work_hours }.where{ story_id == my{self.id} }.select{ work_hours.id }
    WorkHour.where{ id.in( entry_story_work_hours ) }
    
    # tes = TodayEntryStory.joins{ work_hours }.where{ (story_id == my{self.id}) }.select{ sum(work_hours.hours).as(work_hours_total) }.first
    # (tes and tes.work_hours_total.to_f)

    # TodayEntryStory.joins{ work_hours }.where{ (entry_id == my{e.id}) & (story_id == my{s.id}) }.select{ sum(work_hours.hours).as(work_hours_total) }.first.work_hours_total.to_f
  end

  # def work_hours_total_from_entries
  #   Story.joins{ work_hours }.where{ id == my{self.id} }.select{ sum(work_hours.hours).as(total_work_hours) }.first.total_work_hours.to_f
  #   # Story.joins{ entry_stories }.where{ id == my{self.id} }.select{ entry_stories.id }
  # end

  def work_hours_total
    work_hours.inject(0.0){|a,b| a + b.hours}
  end

  # def work_hours_total
  #   work_hours_billable_total + self.hours_worked
  # end
end

=begin
_closed_stories = Story.where{status == 'closed'}
_now = Time.zone.now
_closed_stories.each do |s|
  s.completed_at = _now
  s.save!
end
=end

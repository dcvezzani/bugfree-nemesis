class Story < ActiveRecord::Base
  ACTIVE = "active"
  CLOSED = "closed"
  STATUS_VALUES = [ACTIVE, CLOSED]

  attr_accessible :description, :due_on, :hours_est, :hours_todo, :hours_worked, :stopped_since, :title, :project_id, :status, :completed_at

  belongs_to :project
  has_many :entry_stories
  has_many :entries, through: :entry_stories

  has_many :story_notes, foreign_key: :item_id, source: :story, dependent: :destroy
  has_many :notes, through: :story_notes, source: :note, dependent: :destroy, order: "updated_at asc"

  validates :project_id, :status, presence: true

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
end

=begin
_closed_stories = Story.where{status == 'closed'}
_now = Time.zone.now
_closed_stories.each do |s|
  s.completed_at = _now
  s.save!
end
=end

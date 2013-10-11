class Story < ActiveRecord::Base
  ACTIVE = "active"
  CLOSED = "closed"
  STATUS_VALUES = [ACTIVE, CLOSED]

  attr_accessible :description, :due_on, :hours_est, :hours_todo, :hours_worked, :stopped_since, :title, :project_id, :status

  belongs_to :project
  has_many :entry_stories
  has_many :entries, through: :entry_stories

  validates :project_id, :status, presence: true

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
    debugger
    if(is_open?)
      self.status = CLOSED
      self.hours_worked += self.hours_todo
      self.hours_todo = 0.0
      save
    end
  end
end

class Story < ActiveRecord::Base
  attr_accessible :description, :due_on, :hours_est, :hours_todo, :hours_worked, :stopped_since, :title, :project_id

  belongs_to :project
  has_many :entry_stories
  has_many :entries, through: :entry_stories

  validates :project_id, presence: true

  def same_attribute_values?(attrs)
    self.attributes.each do |attr, value|
      if(attrs.keys.include?(attr) and attrs[attr].to_f != value)
        return false
      end
    end
    return true
  end
end

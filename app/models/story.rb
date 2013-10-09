class Story < ActiveRecord::Base
  attr_accessible :description, :due_on, :hours_est, :hours_todo, :hours_worked, :stopped_since, :title
end

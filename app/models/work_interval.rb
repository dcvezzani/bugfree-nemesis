class WorkInterval < ActiveRecord::Base
  attr_accessible :entry_id, :ended_at, :started_at

  belongs_to :entry
end

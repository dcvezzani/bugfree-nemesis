class WorkInterval < ActiveRecord::Base
  attr_accessible :ended_at, :entry_id, :started_at

  validates :entry_id, presence: true

  validate :ended_at_must_follow_started_at, unless: "ended_at.nil? or started_at.nil?"
 
  def ended_at_must_follow_started_at
    if ended_at < started_at
      errors.add(:ended_at, "must come after started_at")
    end
  end

  def is_active?
    (entry_id and started_at and ended_at.nil?)
  end

  def is_complete?
    (entry_id and started_at and ended_at)
  end

  def delta
    if(is_complete?)
      '%.2f' % ((ended_at - started_at) / 1.hour)
      # ((ended_at - started_at) / 1.hour).round
      # ((ended_at - started_at) / 1.hour).round(-2)
      # ((ended_at - started_at) / 1.hour).roundTo(100)
    else
      0
    end
  end
end

=begin
  e = Entry.last
  e.work_intervals << WorkInterval.new(started_at: Time.now - 6.hours, ended_at: Time.now - 4.hours)
  e.work_intervals << WorkInterval.new(started_at: Time.now - 4.hours, ended_at: Time.now - 2.hours)
  e.work_intervals << WorkInterval.new(started_at: Time.now - 2.hours, ended_at: Time.now - 0.hours)
  e.save!

  wi = WorkInterval.create!(started_at: Time.now - 2.hours)
=end

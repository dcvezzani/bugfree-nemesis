class Entry < ActiveRecord::Base
  attr_accessible :recorded_for, :show_stopper_log, :title, :todays_log, :yesterdays_log, :notes

  has_many :entry_stories
  has_many :stories, through: :entry_stories

  has_many :yesterday_entry_stories
  has_many :yesterdays_stories, through: :yesterday_entry_stories, source: :story

  has_many :today_entry_stories
  has_many :todays_stories, through: :today_entry_stories, source: :story

  has_many :show_stopper_entry_stories
  has_many :show_stopper_stories, through: :show_stopper_entry_stories, source: :story

  has_many :work_intervals
  has_many :sorted_active_work_intervals, class_name: "WorkInterval", conditions: ["ended_at is null and started_at is not null"], order: "started_at desc"
  has_many :sorted_complete_work_intervals, class_name: "WorkInterval", conditions: ["ended_at is not null and started_at is not null"], order: "ended_at desc"

  def most_recent_work_interval
    active_work_interval = sorted_active_work_intervals.first
    complete_work_interval = sorted_complete_work_intervals.first

    if(active_work_interval.nil? and complete_work_interval.nil?)
      nil

    elsif(active_work_interval.nil?)
      complete_work_interval

    elsif(complete_work_interval.nil?)
      active_work_interval

    elsif(active_work_interval.started_at > complete_work_interval.ended_at)
      active_work_interval

    else
      complete_work_interval
    end
  end

  def active_work_interval_exists?
    (sorted_active_work_intervals.length > 0)
  end
end

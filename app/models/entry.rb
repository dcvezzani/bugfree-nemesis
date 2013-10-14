class Entry < ActiveRecord::Base
  attr_accessible :recorded_for, :show_stopper_log, :title, :todays_log, :yesterdays_log, :notes, :project_id

  belongs_to :project

  has_many :entry_stories
  has_many :stories, through: :entry_stories

  has_many :yesterday_entry_stories
  has_many :yesterdays_stories, through: :yesterday_entry_stories, source: :story

  has_many :today_entry_stories
  has_many :todays_stories, through: :today_entry_stories, source: :story

  has_many :show_stopper_entry_stories
  has_many :show_stopper_stories, through: :show_stopper_entry_stories, source: :story

  has_many :work_intervals
  has_many :sorted_work_intervals, class_name: "WorkInterval", conditions: ["ended_at is not null or started_at is not null"], order: "started_at asc"
  has_many :sorted_active_work_intervals, class_name: "WorkInterval", conditions: ["ended_at is null and started_at is not null"], order: "started_at asc"
  has_many :sorted_complete_work_intervals, class_name: "WorkInterval", conditions: ["ended_at is not null and started_at is not null"], order: "ended_at asc"

  validates :project_id, presence: true


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

  def total_hours_worked(options={})
    estimate_flag = options[:estimate]
    provide_estimate_ended_at_date = options[:estimate_ended_at]
    current_time = Time.zone.now

    if(work_intervals.length < 1)
      if(provide_estimate_ended_at_date)
        return [0.0, current_time]
      else
        0.0
      end
    end

    res = if(estimate_flag)
      sorted_work_intervals.inject(0.0){|a,b| 
        b_delta = (b.ended_at.blank?) ? (b.delta(current_time)) : b.delta
        a + b_delta
      }
    else
      sorted_complete_work_intervals.inject(0.0){|a,b| 
        b.delta
        a + b_delta
      }
    end

    if(provide_estimate_ended_at_date)
      ended_at = (sorted_work_intervals.last.ended_at.nil?) ? current_time : sorted_work_intervals.last.ended_at
      [res, ended_at]
    else
      res
    end
  end

  def work_day_started_at
    sorted_complete_work_intervals.first.started_at
  end

  def work_day_ended_at
    sorted_complete_work_intervals.last.ended_at
  end

  # there doesn't appear to be any difference whether :precise is used or not
  # there might be some performance benefits
  def work_day_ends_at(options={})
    be_precise = options[:precise]

    if(be_precise)
      hours_worked, interval_ended_at = total_hours_worked({estimate: true, estimate_ended_at: true})
      hours_delta = WorkInterval.round_by((8 - hours_worked).hours)

      (interval_ended_at + hours_delta.hours)
     
    else
      rounded_work_day_ends_at(options)
    end
  end

  def rounded_work_day_ends_at(options={})
    # how many hours are left?
    hours_worked, mark_start = total_hours_worked({estimate: true, estimate_ended_at: true})
    hours_delta = WorkInterval.round_by((8 - hours_worked).hours)

    (mark_start + hours_delta.hours)
  end

end

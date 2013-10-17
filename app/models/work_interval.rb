class WorkInterval < ActiveRecord::Base
  attr_accessible :ended_at, :entry_id, :started_at, :project_id

  belongs_to :project
  belongs_to :entry

  validates :project_id, :entry_id, presence: true
  validate :ended_at_must_follow_started_at, unless: "ended_at.nil? or started_at.nil?"
 
  def ended_at_must_follow_started_at
    if ended_at < started_at
      errors.add(:ended_at, "must come after started_at")
    end
  end

  def is_active?(marked_at=ended_at)
    (!(entry_id and started_at).nil? and marked_at.nil?)
  end

  def is_complete?(marked_at=ended_at)
    !(entry_id and started_at and marked_at).nil?
  end

  # ##
  # # rounds a Time or DateTime to the neares 15 minutes
  # def round_to_15_minutes(minutes)
  #   rounded = Time.at((minutes.to_i / 900.0).round * 900)
  #   # t.is_a?(DateTime) ? rounded.to_datetime : rounded
  # end

  def delta(mrk_end_at=ended_at, mrk_start_at=started_at)
    if(is_complete?(mrk_end_at) and (mrk_end_at > mrk_start_at))
      #'%.2f' % (((mrk_end_at - mrk_start_at) / 30.minutes) / 1.hour)
      # interval_min = (('%.2f' % ((mrk_end_at - mrk_start_at) / 15.minutes)).to_f / 0.25).floor * 0.25
      # [interval_min, interval_min * 15]

      # interval_min = (('%.2f' % ((mrk_end_at - mrk_start_at) / 30.minutes)).to_f / 0.5).ceil * 0.5
      # [interval_min, interval_min * 30]
      #

      WorkInterval.round_by((mrk_end_at - mrk_start_at))

    else
      0
    end
  end

  # ROUND_BY_INTERVAL=(7.5).minutes
  ROUND_BY_INTERVAL=30.minutes
  def self.round_by(delta, hour_interval=ROUND_BY_INTERVAL)
    midpoint = (hour_interval.to_f / 1.hour.to_f)
    final_conversion = 1 / midpoint.to_f

    diff = (delta / hour_interval)
    floor = (delta / hour_interval).floor
    radix = diff - floor

    res = if(radix > midpoint)
      (floor.to_f + 1.0)
    else
      floor.to_f
    end

    # [diff, res, radix]
    (res / final_conversion)
  end

  def update_times(attrs)
    res = false

    begin
      if(!started_at.nil? and attrs.has_key?(:started_at))
        us_pacific = ActiveSupport::TimeZone.us_zones.find{|x| x.name == "Pacific Time (US & Canada)"}

        # started_at = us_pacific.parse(attrs[:started_at]) if(!attrs[:started_at].empty?)
        # ended_at = us_pacific.parse(attrs[:ended_at]) if(!attrs[:ended_at].empty?)

        self.started_at = us_pacific.parse(attrs[:started_at]) if(!attrs[:started_at].empty?)
        self.ended_at = (attrs[:ended_at].empty?) ? nil : us_pacific.parse(attrs[:ended_at])
        res = save
      end

    rescue Exception => e
      Rails.logger.warn "Unable to parse time: #{e.message}"
      Rails.logger.debug e.backtrace
    end

    return res
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

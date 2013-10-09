class Entry < ActiveRecord::Base
  attr_accessible :recorded_for, :show_stopper_log, :title, :todays_log, :yesterdays_log

  has_many :entry_stories
  has_many :stories, through: :entry_stories

  has_many :yesterday_entry_stories
  has_many :yesterdays_stories, through: :yesterday_entry_stories, source: :story

  has_many :today_entry_stories
  has_many :todays_stories, through: :today_entry_stories, source: :story

  has_many :show_stopper_entry_stories
  has_many :show_stopper_stories, through: :show_stopper_entry_stories, source: :story
end

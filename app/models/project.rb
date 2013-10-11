class Project < ActiveRecord::Base
  attr_accessible :description, :name, :slug

  has_many :entries
  has_many :stories
end

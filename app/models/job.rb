class Job < ActiveRecord::Base
  has_many :events
end

class Sleep < ActiveRecord::Base
	belongs_to :user

  validates_presence_of :start_time, :finish_time, :time, :quality
end

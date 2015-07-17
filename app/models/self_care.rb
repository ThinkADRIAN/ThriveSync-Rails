class SelfCare < ActiveRecord::Base
	belongs_to :user

  validates :counseling, :medication, :meditation, :exercise, :inclusion => [true, false]
  validates_presence_of :timestamp
end

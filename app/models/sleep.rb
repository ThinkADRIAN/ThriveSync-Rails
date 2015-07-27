class Sleep < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :start_time, :finish_time
  validates :time, numericality: {only_integer: true}
  validates :quality, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4}
end

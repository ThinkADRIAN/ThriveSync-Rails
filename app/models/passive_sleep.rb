class PassiveSleep < ActiveRecord::Base
  belongs_to :passive_data_point

  validates :value, numericality: {only_float: true, greater_than_or_equal_to: 0}, :allow_nil => true
  #validates_presence_of :value, :unit
end

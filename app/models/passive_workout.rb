class PassiveWorkout < ActiveRecord::Base
  belongs_to :passive_data_point

  validates :kcal_burned_value, numericality: {only_float: true, greater_than_or_equal_to: 0}
  validates :distance_value, numericality: {only_float: true, greater_than_or_equal_to: 0}
  #validates_presence_of :workout_type
end

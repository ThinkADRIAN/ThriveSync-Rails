class PassiveActivity < ActiveRecord::Base
  belongs_to :passive_data_point

  validates :value, numericality: {only_float: true, greater_than_or_equal_to: 0}
  validates :kcal_burned_value, numericality: {only_float: true, greater_than_or_equal_to: 0}
  validates :step_count, numericality: {only_float: true, greater_than_or_equal_to: 0}
  validates_presence_of :type
end

class PassiveSleep < ActiveRecord::Base
  belongs_to :passive_data_point

  validates_presence_of :value, :unit
end

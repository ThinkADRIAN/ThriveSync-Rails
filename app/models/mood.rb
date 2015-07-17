class Mood < ActiveRecord::Base
	belongs_to :user

	validates_presence_of :mood_rating, :anxiety_rating, :irritability_rating, :timestamp
end

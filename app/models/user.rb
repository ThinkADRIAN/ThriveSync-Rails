class User < ParseUser
	fields :objectID, :username, :UserData, :firstName, :lastName, :completedFirstEntry, :completedFirstStreak, :rewardEnabled, :streakCounter, :lastSaveDate

	fields :email

	validates_presence_of :username
end

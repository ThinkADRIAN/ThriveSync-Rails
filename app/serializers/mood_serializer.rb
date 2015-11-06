class MoodSerializer < ActiveModel::Serializer
  attributes :id, :mood_rating, :anxiety_rating, :irritability_rating, :timestamp, :created_at, :updated_at, :user_id
end

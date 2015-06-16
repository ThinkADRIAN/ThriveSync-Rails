class RewardSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :completed_first_entry, :completed_first_streak, :rewards_enabled
end

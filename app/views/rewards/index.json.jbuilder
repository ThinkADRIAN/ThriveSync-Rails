json.array!(@rewards) do |reward|
  json.extract! reward, :id, :user_id, :completed_first_entry, :completed_first_streak, :rewards_enabled
  json.url reward_url(reward, format: :json)
end

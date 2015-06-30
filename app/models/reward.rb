class Reward < ActiveRecord::Base
	belongs_to :user

  def set_rewards_enabled(bool_value)
    self.rewards_enabled = bool_value
    self.save
  end

  def is_rewards_enabled?
    return self.read_attribute(rewards_enabled)
  end
end

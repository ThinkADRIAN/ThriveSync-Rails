class Reward < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :rewards_enabled

  def set_rewards_enabled(bool_value)
    self.rewards_enabled = bool_value
    self.save
  end

  def is_rewards_enabled?
    return self.read_attribute(rewards_enabled)
  end
end

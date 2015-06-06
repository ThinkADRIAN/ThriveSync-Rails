class Reward < ActiveRecord::Base
	belongs_to :user

  after_initialize :init

  def init
    self.completed_first_entry ||= false
    self.completed_first_streak ||= false
    self.rewards_enabled ||= true
  end

  def mark_first_entry_completed
    self.completed_first_entry = true
    self.save
  end

  def is_first_entry_completed?
    return self.read_attribute(completed_first_entry)
  end

  def mark_first_streak_completed
    self.completed_first_streak = true
    self.save
  end

  def is_first_streak_completed?
    return self.read_attribute(completed_first_streak)
  end

  def set_rewards_enabled(bool_value)
    self.rewards_enabled = bool_value
    self.save
  end

  def is_rewards_enabled?
    return self.read_attribute(rewards_enabled)
  end
end

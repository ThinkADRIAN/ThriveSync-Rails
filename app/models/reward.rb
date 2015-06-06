class Reward < ActiveRecord::Base
	belongs_to :user

  after_initialize :init

  def init
    self.completed_first_entry ||= false
    self.completed_first_streak ||= false
    self.rewards_enabled ||= true
  end

  def self.mark_first_entry_completed
    self.completed_first_entry = true
    self.save
  end

  def self.mark_first_streak_completed
    self.completed_first_streak = true
    self.save
  end

  def self.set_rewards_enabled(bool_value)
    self.rewards_enabled = bool_value
    self.save
  end
end

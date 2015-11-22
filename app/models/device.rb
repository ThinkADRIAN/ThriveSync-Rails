class Device < ActiveRecord::Base
  attr_accessible :enabled, :token, :user, :platform
  belongs_to :user
  validates_uniqueness_of :token, :scope => :user_id
end

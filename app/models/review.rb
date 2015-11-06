class Review < ActiveRecord::Base
  belongs_to :user

  after_initialize :init

  def init
    self.review_counter ||= 0
  end
end

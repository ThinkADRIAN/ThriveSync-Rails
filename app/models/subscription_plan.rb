class SubscriptionPlan < ActiveRecord::Base
  include Payola::Plan

  validates_uniqueness_of :stripe_id

  def redirect_path(subscription)
    # you can return any path here, possibly referencing the given subscription
    '/'
  end
end

class SubscriptionPlanSerializer < ActiveModel::Serializer
  attributes :id, :stripe_id, :name, :description, :amount, :interval,  :interval_count, :trial_period_days
end

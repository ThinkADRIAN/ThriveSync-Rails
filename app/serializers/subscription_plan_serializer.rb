class SubscriptionPlanSerializer < ActiveModel::Serializer
  attributes :id, :amount, :interval, :stripe_id, :name, :interval_count, :trial_period_days
end

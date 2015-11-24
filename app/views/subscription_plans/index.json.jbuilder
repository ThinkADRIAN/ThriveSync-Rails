json.array!(@subscription_plans) do |subscription_plan|
  json.extract! subscription_plan, :id, :amount, :interval, :stripe_id, :name, :interval_count, :trial_period_days
  json.url subscription_plan_url(subscription_plan, format: :json)
end

FactoryGirl.define do
  factory :subscription_plan do
    amount 1
interval "MyString"
stripe_id "MyString"
name "MyString"
interval_count 1
trial_period_days 1
  end

end

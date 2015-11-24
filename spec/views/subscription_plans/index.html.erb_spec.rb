require 'rails_helper'

RSpec.describe "subscription_plans/index", type: :view do
  before(:each) do
    assign(:subscription_plans, [
      SubscriptionPlan.create!(
        :amount => 1,
        :interval => "Interval",
        :stripe_id => "Stripe",
        :name => "Name",
        :interval_count => 2,
        :trial_period_days => 3
      ),
      SubscriptionPlan.create!(
        :amount => 1,
        :interval => "Interval",
        :stripe_id => "Stripe",
        :name => "Name",
        :interval_count => 2,
        :trial_period_days => 3
      )
    ])
  end

  it "renders a list of subscription_plans" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Interval".to_s, :count => 2
    assert_select "tr>td", :text => "Stripe".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end

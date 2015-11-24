require 'rails_helper'

RSpec.describe "subscription_plans/show", type: :view do
  before(:each) do
    @subscription_plan = assign(:subscription_plan, SubscriptionPlan.create!(
      :amount => 1,
      :interval => "Interval",
      :stripe_id => "Stripe",
      :name => "Name",
      :interval_count => 2,
      :trial_period_days => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Interval/)
    expect(rendered).to match(/Stripe/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end

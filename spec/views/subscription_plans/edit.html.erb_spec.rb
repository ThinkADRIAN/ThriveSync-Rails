require 'rails_helper'

RSpec.describe "subscription_plans/edit", type: :view do
  before(:each) do
    @subscription_plan = assign(:subscription_plan, SubscriptionPlan.create!(
      :amount => 1,
      :interval => "MyString",
      :stripe_id => "MyString",
      :name => "MyString",
      :interval_count => 1,
      :trial_period_days => 1
    ))
  end

  it "renders the edit subscription_plan form" do
    render

    assert_select "form[action=?][method=?]", subscription_plan_path(@subscription_plan), "post" do

      assert_select "input#subscription_plan_amount[name=?]", "subscription_plan[amount]"

      assert_select "input#subscription_plan_interval[name=?]", "subscription_plan[interval]"

      assert_select "input#subscription_plan_stripe_id[name=?]", "subscription_plan[stripe_id]"

      assert_select "input#subscription_plan_name[name=?]", "subscription_plan[name]"

      assert_select "input#subscription_plan_interval_count[name=?]", "subscription_plan[interval_count]"

      assert_select "input#subscription_plan_trial_period_days[name=?]", "subscription_plan[trial_period_days]"
    end
  end
end

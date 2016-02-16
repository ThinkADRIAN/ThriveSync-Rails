require 'rails_helper'

RSpec.describe "passive_activities/index", type: :view do
  before(:each) do
    assign(:passive_activities, [
      PassiveActivity.create!(
        :passive_data_point_id => 1,
        :type => "Type",
        :value => 1.5,
        :unit => "Unit",
        :kcal_burned_value => 1.5,
        :kcal_burned_unit => "Kcal Burned Unit",
        :step_count => 1.5
      ),
      PassiveActivity.create!(
        :passive_data_point_id => 1,
        :type => "Type",
        :value => 1.5,
        :unit => "Unit",
        :kcal_burned_value => 1.5,
        :kcal_burned_unit => "Kcal Burned Unit",
        :step_count => 1.5
      )
    ])
  end

  it "renders a list of passive_activities" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Unit".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Kcal Burned Unit".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end

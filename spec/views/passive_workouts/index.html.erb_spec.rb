require 'rails_helper'

RSpec.describe "passive_workouts/index", type: :view do
  before(:each) do
    assign(:passive_workouts, [
      PassiveWorkout.create!(
        :passive_data_point_id => 1,
        :workout_type => "Workout Type",
        :kcal_burned_value => 1.5,
        :kcal_burned_unit => "Kcal Burned Unit",
        :distance_value => 1.5,
        :distance_unit => "Distance Unit"
      ),
      PassiveWorkout.create!(
        :passive_data_point_id => 1,
        :workout_type => "Workout Type",
        :kcal_burned_value => 1.5,
        :kcal_burned_unit => "Kcal Burned Unit",
        :distance_value => 1.5,
        :distance_unit => "Distance Unit"
      )
    ])
  end

  it "renders a list of passive_workouts" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Workout Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Kcal Burned Unit".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Distance Unit".to_s, :count => 2
  end
end

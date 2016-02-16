require 'rails_helper'

RSpec.describe "passive_workouts/edit", type: :view do
  before(:each) do
    @passive_workout = assign(:passive_workout, PassiveWorkout.create!(
      :passive_data_point_id => 1,
      :workout_type => "MyString",
      :kcal_burned_value => 1.5,
      :kcal_burned_unit => "MyString",
      :distance_value => 1.5,
      :distance_unit => "MyString"
    ))
  end

  it "renders the edit passive_workout form" do
    render

    assert_select "form[action=?][method=?]", passive_workout_path(@passive_workout), "post" do

      assert_select "input#passive_workout_passive_data_point_id[name=?]", "passive_workout[passive_data_point_id]"

      assert_select "input#passive_workout_workout_type[name=?]", "passive_workout[workout_type]"

      assert_select "input#passive_workout_kcal_burned_value[name=?]", "passive_workout[kcal_burned_value]"

      assert_select "input#passive_workout_kcal_burned_unit[name=?]", "passive_workout[kcal_burned_unit]"

      assert_select "input#passive_workout_distance_value[name=?]", "passive_workout[distance_value]"

      assert_select "input#passive_workout_distance_unit[name=?]", "passive_workout[distance_unit]"
    end
  end
end

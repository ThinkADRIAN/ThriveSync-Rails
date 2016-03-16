require 'rails_helper'

RSpec.describe "passive_workouts/show", type: :view do
  before(:each) do
    @passive_workout = assign(:passive_workout, PassiveWorkout.create!(
      :passive_data_point_id => 1,
      :workout_type => "Workout Type",
      :kcal_burned_value => 1.5,
      :kcal_burned_unit => "Kcal Burned Unit",
      :distance_value => 1.5,
      :distance_unit => "Distance Unit"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Workout Type/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Kcal Burned Unit/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Distance Unit/)
  end
end

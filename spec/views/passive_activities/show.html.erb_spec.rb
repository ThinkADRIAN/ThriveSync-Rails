require 'rails_helper'

RSpec.describe "passive_activities/show", type: :view do
  before(:each) do
    @passive_activity = assign(:passive_activity, PassiveActivity.create!(
      :passive_data_point_id => 1,
      :type => "Type",
      :value => 1.5,
      :unit => "Unit",
      :kcal_burned_value => 1.5,
      :kcal_burned_unit => "Kcal Burned Unit",
      :step_count => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Unit/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/Kcal Burned Unit/)
    expect(rendered).to match(/1.5/)
  end
end

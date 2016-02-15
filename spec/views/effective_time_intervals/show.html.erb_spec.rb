require 'rails_helper'

RSpec.describe "effective_time_intervals/show", type: :view do
  before(:each) do
    @effective_time_interval = assign(:effective_time_interval, EffectiveTimeInterval.create!(
      :passive_data_point_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
  end
end

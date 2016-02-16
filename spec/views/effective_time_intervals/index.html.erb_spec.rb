require 'rails_helper'

RSpec.describe "effective_time_intervals/index", type: :view do
  before(:each) do
    assign(:effective_time_intervals, [
      EffectiveTimeInterval.create!(
        :passive_data_point_id => 1
      ),
      EffectiveTimeInterval.create!(
        :passive_data_point_id => 1
      )
    ])
  end

  it "renders a list of effective_time_intervals" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end

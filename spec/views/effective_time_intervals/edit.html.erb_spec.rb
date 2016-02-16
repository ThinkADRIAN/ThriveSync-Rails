require 'rails_helper'

RSpec.describe "effective_time_intervals/edit", type: :view do
  before(:each) do
    @effective_time_interval = assign(:effective_time_interval, EffectiveTimeInterval.create!(
      :passive_data_point_id => 1
    ))
  end

  it "renders the edit effective_time_interval form" do
    render

    assert_select "form[action=?][method=?]", effective_time_interval_path(@effective_time_interval), "post" do

      assert_select "input#effective_time_interval_passive_data_point_id[name=?]", "effective_time_interval[passive_data_point_id]"
    end
  end
end

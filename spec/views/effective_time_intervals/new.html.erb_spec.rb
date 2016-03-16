require 'rails_helper'

RSpec.describe "effective_time_intervals/new", type: :view do
  before(:each) do
    assign(:effective_time_interval, EffectiveTimeInterval.new(
      :passive_data_point_id => 1
    ))
  end

  it "renders new effective_time_interval form" do
    render

    assert_select "form[action=?][method=?]", effective_time_intervals_path, "post" do

      assert_select "input#effective_time_interval_passive_data_point_id[name=?]", "effective_time_interval[passive_data_point_id]"
    end
  end
end

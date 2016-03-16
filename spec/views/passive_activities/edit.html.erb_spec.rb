require 'rails_helper'

RSpec.describe "passive_activities/edit", type: :view do
  before(:each) do
    @passive_activity = assign(:passive_activity, PassiveActivity.create!(
      :passive_data_point_id => 1,
      :type => "",
      :value => 1.5,
      :unit => "MyString",
      :kcal_burned_value => 1.5,
      :kcal_burned_unit => "MyString",
      :step_count => 1.5
    ))
  end

  it "renders the edit passive_activity form" do
    render

    assert_select "form[action=?][method=?]", passive_activity_path(@passive_activity), "post" do

      assert_select "input#passive_activity_passive_data_point_id[name=?]", "passive_activity[passive_data_point_id]"

      assert_select "input#passive_activity_type[name=?]", "passive_activity[type]"

      assert_select "input#passive_activity_value[name=?]", "passive_activity[value]"

      assert_select "input#passive_activity_unit[name=?]", "passive_activity[unit]"

      assert_select "input#passive_activity_kcal_burned_value[name=?]", "passive_activity[kcal_burned_value]"

      assert_select "input#passive_activity_kcal_burned_unit[name=?]", "passive_activity[kcal_burned_unit]"

      assert_select "input#passive_activity_step_count[name=?]", "passive_activity[step_count]"
    end
  end
end

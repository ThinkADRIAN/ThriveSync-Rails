require 'rails_helper'

RSpec.describe "passive_sleeps/edit", type: :view do
  before(:each) do
    @passive_sleep = assign(:passive_sleep, PassiveSleep.create!(
      :passive_data_point_id => 1,
      :category_type => "MyString",
      :category_value => "MyString",
      :value => "",
      :unit => "MyString"
    ))
  end

  it "renders the edit passive_sleep form" do
    render

    assert_select "form[action=?][method=?]", passive_sleep_path(@passive_sleep), "post" do

      assert_select "input#passive_sleep_passive_data_point_id[name=?]", "passive_sleep[passive_data_point_id]"

      assert_select "input#passive_sleep_category_type[name=?]", "passive_sleep[category_type]"

      assert_select "input#passive_sleep_category_value[name=?]", "passive_sleep[category_value]"

      assert_select "input#passive_sleep_value[name=?]", "passive_sleep[value]"

      assert_select "input#passive_sleep_unit[name=?]", "passive_sleep[unit]"
    end
  end
end

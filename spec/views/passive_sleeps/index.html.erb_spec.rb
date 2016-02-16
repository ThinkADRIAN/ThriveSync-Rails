require 'rails_helper'

RSpec.describe "passive_sleeps/index", type: :view do
  before(:each) do
    assign(:passive_sleeps, [
      PassiveSleep.create!(
        :passive_data_id => 1,
        :category_type => "Category Type",
        :category_value => "Category Value",
        :value => "",
        :unit => "Unit"
      ),
      PassiveSleep.create!(
        :passive_data_id => 1,
        :category_type => "Category Type",
        :category_value => "Category Value",
        :value => "",
        :unit => "Unit"
      )
    ])
  end

  it "renders a list of passive_sleeps" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Category Type".to_s, :count => 2
    assert_select "tr>td", :text => "Category Value".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Unit".to_s, :count => 2
  end
end

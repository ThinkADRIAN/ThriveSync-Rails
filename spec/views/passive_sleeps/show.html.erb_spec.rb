require 'rails_helper'

RSpec.describe "passive_sleeps/show", type: :view do
  before(:each) do
    @passive_sleep = assign(:passive_sleep, PassiveSleep.create!(
      :passive_data_point_id => 1,
      :category_type => "Category Type",
      :category_value => "Category Value",
      :value => "",
      :unit => "Unit"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Category Type/)
    expect(rendered).to match(/Category Value/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Unit/)
  end
end

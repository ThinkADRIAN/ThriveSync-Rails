require 'rails_helper'

RSpec.describe "pre_defined_cards/index", type: :view do
  before(:each) do
    assign(:pre_defined_cards, [
      PreDefinedCard.create!(
        :text => "Text",
        :category => "Category"
      ),
      PreDefinedCard.create!(
        :text => "Text",
        :category => "Category"
      )
    ])
  end

  it "renders a list of pre_defined_cards" do
    render
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
  end
end

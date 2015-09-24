require 'rails_helper'

RSpec.describe "pre_defined_cards/edit", type: :view do
  before(:each) do
    @pre_defined_card = assign(:pre_defined_card, PreDefinedCard.create!(
      :text => "MyString",
      :category => "MyString"
    ))
  end

  it "renders the edit pre_defined_card form" do
    render

    assert_select "form[action=?][method=?]", pre_defined_card_path(@pre_defined_card), "post" do

      assert_select "input#pre_defined_card_text[name=?]", "pre_defined_card[text]"

      assert_select "input#pre_defined_card_category[name=?]", "pre_defined_card[category]"
    end
  end
end

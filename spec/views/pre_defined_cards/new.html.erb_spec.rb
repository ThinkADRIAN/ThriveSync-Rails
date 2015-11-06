require 'rails_helper'

RSpec.describe "pre_defined_cards/new", type: :view do
  before(:each) do
    assign(:pre_defined_card, PreDefinedCard.new(
      :text => "MyString",
      :category => "MyString"
    ))
  end

  it "renders new pre_defined_card form" do
    render

    assert_select "form[action=?][method=?]", pre_defined_cards_path, "post" do

      assert_select "input#pre_defined_card_text[name=?]", "pre_defined_card[text]"

      assert_select "input#pre_defined_card_category[name=?]", "pre_defined_card[category]"
    end
  end
end

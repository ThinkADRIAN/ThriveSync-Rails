require 'rails_helper'

RSpec.describe "pre_defined_cards/show", type: :view do
  before(:each) do
    @pre_defined_card = assign(:pre_defined_card, PreDefinedCard.create!(
      :text => "Text",
      :category => "Category"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Text/)
    expect(rendered).to match(/Category/)
  end
end

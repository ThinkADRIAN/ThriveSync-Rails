require 'rails_helper'

describe PreDefinedCard, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:pre_defined_card)).to be_valid
  end
  it "is invalid without a text" do
    expect(FactoryGirl.build(:pre_defined_card, text: nil)).to_not be_valid
  end
  it "is invalid without a category" do
    expect(FactoryGirl.build(:pre_defined_card, category: nil)).to_not be_valid
  end
end

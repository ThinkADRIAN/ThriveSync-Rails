require 'rails_helper'

describe Mood do
  it "has a valid factory" do
    expect(FactoryGirl.create(:mood)).to be_valid
  end
  it "is invalid without a mood_rating" do
    expect(FactoryGirl.build(:mood, mood_rating: nil)).to_not be_valid
  end
  it "is invalid without a anxiety_rating" do
    expect(FactoryGirl.build(:mood, anxiety_rating: nil)).to_not be_valid
  end
  it "is invalid without a irritability_rating" do
    expect(FactoryGirl.build(:mood, irritability_rating: nil)).to_not be_valid
  end
  it "is invalid without a timestamp" do
    expect(FactoryGirl.build(:mood, timestamp: nil)).to_not be_valid
  end
end
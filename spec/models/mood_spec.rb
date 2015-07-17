require 'spec_helper' 

describe Mood do 
  it "has a valid factory" do
    FactoryGirl.create(:mood).should be_valid
  end
  it "is invalid without a mood_rating" do
    FactoryGirl.build(:mood, mood_rating: nil).should_not be_valid
  end
  it "is invalid without a anxiety_rating" do
    FactoryGirl.build(:mood, anxiety_rating: nil).should_not be_valid
  end
  it "is invalid without a irritability_rating" do
    FactoryGirl.build(:mood, irritability_rating: nil).should_not be_valid
  end
  it "is invalid without a timestamp" do
    FactoryGirl.build(:mood, timestamp: nil).should_not be_valid
  end
end
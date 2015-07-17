require 'spec_helper' 

describe Sleep do 
  it "has a valid factory" do
    FactoryGirl.create(:sleep).should be_valid
  end
  it "is invalid without a start_time" do
    FactoryGirl.build(:sleep, start_time: nil).should_not be_valid
  end
  it "is invalid without a finish_time" do
    FactoryGirl.build(:sleep, finish_time: nil).should_not be_valid
  end
  it "is invalid without a time" do
    FactoryGirl.build(:sleep, time: nil).should_not be_valid
  end
  it "is invalid without a irritability_rating" do
    FactoryGirl.build(:sleep, quality: nil).should_not be_valid
  end
end
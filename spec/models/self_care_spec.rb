require 'spec_helper' 

describe SelfCare do 
  it "has a valid factory" do
    FactoryGirl.create(:self_care).should be_valid
  end
  it "is invalid without a counseling" do
    FactoryGirl.build(:self_care, counseling: nil).should_not be_valid
  end
  it "is invalid without a medication" do
    FactoryGirl.build(:self_care, medication: nil).should_not be_valid
  end
  it "is invalid without a meditation" do
    FactoryGirl.build(:self_care, meditation: nil).should_not be_valid
  end
  it "is invalid without a exercise" do
    FactoryGirl.build(:self_care, exercise: nil).should_not be_valid
  end
  it "is invalid without a timestamp" do
    FactoryGirl.build(:self_care, timestamp: nil).should_not be_valid
  end
end
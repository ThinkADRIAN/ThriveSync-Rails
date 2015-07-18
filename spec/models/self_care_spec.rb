require 'spec_helper' 

describe SelfCare do 
  it "has a valid factory" do
    expect(FactoryGirl.create(:self_care)).to be_valid
  end
  it "is invalid without a counseling" do
    expect(FactoryGirl.build(:self_care, counseling: nil)).to_not be_valid
  end
  it "is invalid without a medication" do
    expect(FactoryGirl.build(:self_care, medication: nil)).to_not be_valid
  end
  it "is invalid without a meditation" do
    expect(FactoryGirl.build(:self_care, meditation: nil)).to_not be_valid
  end
  it "is invalid without a exercise" do
    expect(FactoryGirl.build(:self_care, exercise: nil)).to_not be_valid
  end
  it "is invalid without a timestamp" do
    expect(FactoryGirl.build(:self_care, timestamp: nil)).to_not be_valid
  end
end
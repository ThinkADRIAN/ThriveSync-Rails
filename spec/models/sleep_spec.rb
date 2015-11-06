require 'rails_helper' 

describe Sleep do 
  it "has a valid factory" do
    expect(FactoryGirl.create(:sleep)).to be_valid
  end
  it "is invalid without a start_time" do
    expect(FactoryGirl.build(:sleep, start_time: nil)).to_not be_valid
  end
  it "is invalid without a finish_time" do
    expect(FactoryGirl.build(:sleep, finish_time: nil)).to_not be_valid
  end
  it "is invalid without a time" do
    expect(FactoryGirl.build(:sleep, time: nil)).to_not be_valid
  end
  it "is invalid without a irritability_rating" do
    expect(FactoryGirl.build(:sleep, quality: nil)).to_not be_valid
  end
end
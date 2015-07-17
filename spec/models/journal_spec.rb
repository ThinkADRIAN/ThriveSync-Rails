require 'spec_helper' 

describe Journal do 
  it "has a valid factory" do
    FactoryGirl.create(:journal).should be_valid
  end
  it "is invalid without a journal_entry" do
    FactoryGirl.build(:journal, journal_entry: nil).should_not be_valid
  end
  it "is invalid without a timestamp" do
    FactoryGirl.build(:journal, timestamp: nil).should_not be_valid
  end
end
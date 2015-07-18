require 'spec_helper' 

describe Journal do 
  it "has a valid factory" do
    expect(FactoryGirl.create(:journal)).to be_valid
  end
  it "is invalid without a journal_entry" do
    expect(FactoryGirl.build(:journal, journal_entry: nil)).to_not be_valid
  end
  it "is invalid without a timestamp" do
    expect(FactoryGirl.build(:journal, timestamp: nil)).to_not be_valid
  end
end
require 'faker' 

FactoryGirl.define do 
  factory :self_care do |f| 
    f.counseling { [true,false].sample }
    f.medication { [true,false].sample }
    f.meditation { [true,false].sample }
    f.exercise { [true,false].sample }
    f.timestamp DateTime.now
  end 
end 
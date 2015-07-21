require 'faker' 

FactoryGirl.define do 
  factory :mood do |f| 
    f.mood_rating { rand(1..7) }
    f.anxiety_rating { rand(1..4) }
    f.irritability_rating { rand(1..4) }
    f.timestamp DateTime.now
    user
  end

  factory :invalid_mood do |f| 
    f.mood_rating { rand(8..15) }
    f.anxiety_rating { rand(5..8) }
    f.irritability_rating { rand(5..8) }
    f.timestamp DateTime.now
    user
  end
end 
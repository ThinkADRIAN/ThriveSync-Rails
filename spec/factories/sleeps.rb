require 'faker' 

FactoryGirl.define do
  sleep_start_time = Faker::Time.between(1.days.ago, 1.days.ago, :evening)#
  sleep_finish_time = sleep_start_time + rand(1..10).hours

	factory :sleep do |f| 
    f.start_time { sleep_start_time }
    f.finish_time { sleep_finish_time }
    f.time { (sleep_finish_time.to_i - sleep_start_time.to_i) / 3600 }
    f.quality { rand(1..4) }
  end 
end 
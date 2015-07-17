require 'faker' 

FactoryGirl.define do 
	factory :journal do |f| 
    f.journal_entry { Faker::Lorem.paragraph(sentence_count = rand(1..38)) }
    f.timestamp DateTime.now
  end 
end 
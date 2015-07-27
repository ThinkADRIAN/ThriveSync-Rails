require 'faker' 

FactoryGirl.define do 
	factory :journal do |f| 
    f.journal_entry { Faker::Lorem.paragraph(sentence_count = rand(1..38)) }
    f.timestamp DateTime.now
    user
  end 

  factory :invalid_journal, class:Journal do |f| 
    f.journal { ["Invalid", "Entry"] }
    f.timestamp DateTime.now
    user
  end
end 
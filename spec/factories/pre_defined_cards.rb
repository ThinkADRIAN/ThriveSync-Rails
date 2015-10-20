require 'faker'

FactoryGirl.define do
  factory :pre_defined_card do |f|
    f.text { Faker::Lorem.sentence }
    f.category { Faker::Lorem.word }
  end
end

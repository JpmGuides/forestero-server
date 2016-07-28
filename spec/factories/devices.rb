FactoryGirl.define do
  factory :device do
    uuid Faker::Number.number(10)
    name Faker::Lorem.word
  end
end

FactoryGirl.define do
  factory :day_text do
    text Faker::Lorem.words(50).join(' ')
    date Faker::Date.between(2.days.ago, Date.today)
  end
end

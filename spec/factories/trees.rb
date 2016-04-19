FactoryGirl.define do
  factory :tree do
    report

    trait :complete do
      tiny { Faker::Number.number(2) }
      small { Faker::Number.number(2) }
      large { Faker::Number.number(2) }
      mature { Faker::Number.number(2) }
      ripe { Faker::Number.number(2) }
      damaged { Faker::Number.number(2) }
      blackpod { Faker::Number.number(2) }
    end
  end
end

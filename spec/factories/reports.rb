FactoryGirl.define do
  factory :report do
    taken_at { DateTime.now }
    site_reference { Faker::Lorem.characters(10) }
    site_id { Faker::Lorem.characters(10) }
    visit_id { Faker::Lorem.characters(10) }

    trait :complete do
      humiditiy { Faker::Number.number(2) }
      canopy { Faker::Number.number(2) }
      flowers { Faker::Number.number(2) }
      bp { Faker::Number.number(2) }
      harvesting { Faker::Boolean.boolean }
      drying { Faker::Boolean.boolean }
      fertilizer { Faker::Boolean.boolean }
      wilt { Faker::Boolean.boolean }
    end
  end
end

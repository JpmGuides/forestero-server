FactoryGirl.define do
  factory :user, class: User do
    email                 { Faker::Internet.email }
    password              "password"
    password_confirmation "password"

    trait :admin do
      admin true
    end
  end
end

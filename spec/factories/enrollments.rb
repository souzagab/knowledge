FactoryBot.define do
  factory :enrollment do
    user
    course

    trait :invalid do
      user { nil }
      course { nil }
    end
  end
end

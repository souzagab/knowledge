FactoryBot.define do
  factory :attendee do
    user
    course

    trait :invalid do
      user { nil }
      course { nil }
    end
  end
end

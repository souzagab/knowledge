FactoryBot.define do
  factory :course do
    title { Faker::Educator.course_name }
    description { Faker::Educator.subject }

    thumbnail {}

    trait :invalid do
      title { nil }
      description { nil }
    end
  end
end

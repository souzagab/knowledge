FactoryBot.define do
  factory :course do
    title { Faker::Educator.course_name }
    description { Faker::Educator.subject }

    trait :invalid do
      title { nil }
      description { nil }
    end
  end
end

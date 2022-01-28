FactoryBot.define do
  factory :content do
    course

    name { Faker::Educator.subject }
    description { [nil, Faker::Lorem.paragraph].sample }

    file {}

    trait :invalid do
      course { nil }
      name { nil }
    end
  end
end

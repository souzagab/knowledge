FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { SecureRandom.hex(8) }

    # role { :user } # defaults to user

    trait :admin do
      role { :admin }
    end

    trait :invalid do
      name { nil }

      email { "invalid-email" }
      password { nil }
    end

  end
end

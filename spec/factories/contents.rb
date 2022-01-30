FactoryBot.define do
  factory :content do
    course

    name { Faker::Educator.subject }
    description { [nil, Faker::Lorem.paragraph].sample }

    trait :invalid do
      course { nil }
      name { nil }
    end

    after(:build) do |instance, _evaluator|
      file_name = %w[images/image.png images/image.jpg videos/sample.mp4].sample
      file_path = Rails.root.join("spec", "fixtures", "files", file_name)

      instance.file.attach io: File.open(file_path),
                                filename: file_path.basename,
                                content_type: Marcel::MimeType.for(file_path)
    end
  end
end

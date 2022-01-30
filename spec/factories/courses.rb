FactoryBot.define do
  factory :course do
    title { Faker::Educator.course_name }
    description { Faker::Educator.subject }


    trait :invalid do
      title { nil }
      description { nil }
    end

    after(:build) do |instance, _evaluator|
      file_name = %w[images/image.png images/image.jpg].sample
      file_path = Rails.root.join("spec", "fixtures", "files", file_name)

      instance.thumbnail.attach io: File.open(file_path),
                                filename: file_path.basename,
                                content_type: Marcel::MimeType.for(file_path)
    end
  end
end

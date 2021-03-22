FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"
  end

  factory :question do
    title
    body { "Body of some hard question" }
    author { association :user }

    trait :invalid do
      title { nil }
    end

    trait :with_attachment do
      after(:build) do |question|
        question.files.attach(io: File.open('spec/rails_helper.rb'), filename: 'rails_helper.rb')
      end
    end
  end
end

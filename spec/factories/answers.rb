FactoryBot.define do
  sequence :body do |n|
    "Great answer to the question #{n}"
  end

  factory :answer do
    body
    question
    author { association :user }

    trait :invalid do
      body { nil }
    end

    trait :the_best do
      the_best { true }
    end

    trait :with_attachment do
      after(:build) do |answer|
        answer.files.attach(io: File.open('spec/rails_helper.rb'), filename: 'rails_helper.rb')
      end
    end
  end
end

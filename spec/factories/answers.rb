FactoryBot.define do
  factory :answer do
    body { "Great answer to the question" }
    question
    author { association :user }

    trait :invalid do
      body { nil }
    end
  end
end

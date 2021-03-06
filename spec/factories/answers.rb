FactoryBot.define do
  factory :answer do
    body { "Great answer to the question" }
    question

    trait :invalid do
      body { nil }
    end
  end
end

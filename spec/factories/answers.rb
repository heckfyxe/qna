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
  end
end

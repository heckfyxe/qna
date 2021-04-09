FactoryBot.define do
  factory :comment do
    body { "MyString" }
    author { association :user }
    for_question

    trait :for_question do
      association :commentable, factory: :question
    end

    trait :for_answer do
      association :commentable, factory: :answer
    end

    trait :invalid do
      body { '' }
    end
  end
end

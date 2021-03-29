FactoryBot.define do
  factory :link do
    name { "LinkName" }
    url { "https://google.com" }
    for_question

    trait :for_question do
      association :linkable, factory: :question
    end

    trait :for_answer do
      association :linkable, factory: :answer
    end
  end
end

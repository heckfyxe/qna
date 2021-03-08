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
  end
end

FactoryBot.define do
  factory :badge do
    sequence :title do |i|
      "Badge#{i}"
    end

    after(:build) do |badge|
      badge.image.attach(io: File.open('spec/assets/badge.png'), filename: 'badge.png')
    end

    question
  end
end

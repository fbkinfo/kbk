FactoryGirl.define do
  factory :investigation do
    title                 { Faker::HipsterIpsum.sentence }
    description           { Faker::Lorem.paragraph }
    user

    trait :published do
      published_until { Date.current }
    end
  end
end
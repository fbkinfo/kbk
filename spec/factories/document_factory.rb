FactoryGirl.define do
  factory :document do
    organization
    title         { Faker::HipsterIpsum.sentence }
    description   { Faker::Lorem.paragraph }
    document_date { Date.today }
    due_date      { Date.today }
    user          { FactoryGirl.create(:user) }
    investigation { FactoryGirl.create(:investigation, user: user) }
    author        { user.author }

    before(:create) do |document|
      document.snapshots << FactoryGirl.build(:snapshot)
    end

    trait :published do
      investigation { FactoryGirl.create(:investigation, :published, user: user) }
    end
  end
end

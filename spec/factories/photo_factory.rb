FactoryGirl.define do
  factory :photo do
    investigation
    image { FileFixtures.photo }
    entry_date { Date.current }
  end
end
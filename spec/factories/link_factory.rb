FactoryGirl.define do
  factory :link do
    investigation
    title { Faker::HipsterIpsum.sentence }
    comment { Faker::HipsterIpsum.sentence }
    url "http://youtube.com/watch?v=n8tsfHoEPlU"
    entry_date { Date.current }
  end
end

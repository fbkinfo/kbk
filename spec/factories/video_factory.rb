FactoryGirl.define do
  factory :video do
    investigation
    body "http://youtube.com/watch?v=n8tsfHoEPlU"
    entry_date { Date.current }
  end
end

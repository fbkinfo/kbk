FactoryGirl.define do
  factory :snapshot do
    number 1
    original_scan { FileFixtures.photo }
  end
end

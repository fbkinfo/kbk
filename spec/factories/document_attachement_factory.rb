FactoryGirl.define do
  factory :document_attachement do
    file { FileFixtures.photo }
  end
end

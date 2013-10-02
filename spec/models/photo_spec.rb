require 'spec_helper'

describe Photo do
  it "can cleanup old records" do
    photo = create(:photo, investigation_id: nil, created_at: 3.weeks.ago)
    described_class.cleanup

    expect(described_class.exists?(id: photo.id)).to be_false
  end
end

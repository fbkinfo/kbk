require 'spec_helper'

describe Organization do
  context "being validated" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end

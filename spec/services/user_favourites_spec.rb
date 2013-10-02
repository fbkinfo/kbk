require 'spec_helper'

describe UserFavourites do
  let(:user) { create(:user) }
  let(:favouritable) { create(:document, user: user) }

  it "can be added to favourites" do
    expect(user.favourites.count).to eq 0

    expect {
      described_class.new(user).add(favouritable)
    }.to change(Favourite, :count).by(1)

    expect(user.favourites.last.entry).to eq favouritable
  end

  context "being already favourited" do
    it "don't create duplicates on add" do
      user_favourites = described_class.new(user)
      user_favourites.add(favouritable)

      expect {
        2.times do
          user_favourites.add(favouritable)
        end
      }.to change(Favourite, :count).by(0)
    end

    it "can be removed from favourites" do
      user_favourites = described_class.new(user)
      user_favourites.add(favouritable)

      expect {
        user_favourites.remove(favouritable)
      }.to change(Favourite, :count).by(-1)

      expect(user.favourites.count).to eq 0
    end
  end
end

require 'spec_helper'

describe User do
  it "creates author" do
    user = nil
    expect {
      user = create(:user, name: "Navalny")
    }.to change(Author, :count).by(1)

    expect(user.author.name).to eq user.name
    expect(user.author.user_id).to eq user.id
  end
end

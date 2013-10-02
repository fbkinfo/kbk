require 'spec_helper'

describe Signup do
  let(:valid_user) { User.new(email: "putin@vor.ru", name: "Vor") }
  let(:fake_mailer) { double(deliver: true) }

  it "assings random password to user" do
    signup = described_class.new(valid_user)
    signup.save

    expect(signup.user.password.size).to eq(8)
  end

  it "sends welcome email to user" do
    signup = described_class.new(valid_user)

    expect(UserMailer).to receive(:welcome_email).once.and_return(fake_mailer)
    expect(signup.save).to be_true
  end

  it "returns false if user is invalid on save" do
    signup = described_class.new(User.new)
    expect(signup.save).to be_false
    expect(signup.user.errors.size).to be > 0
  end

  it "passed random password to UserMailer on save" do
    signup = described_class.new(valid_user)
    signup.stub(:random_password).and_return("putinvor")

    expect(UserMailer).to receive(:welcome_email).once.with(instance_of(Fixnum), "putinvor").and_return(fake_mailer)
    signup.save
  end
end

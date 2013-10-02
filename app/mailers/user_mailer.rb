class UserMailer < ActionMailer::Base
  default from: "it@fbk.info"

  def welcome_email(user_id, password)
    @user = User.find(user_id)
    @password = password

    mail to: @user.email
  end
end

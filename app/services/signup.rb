class Signup
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def save
    @user.password = random_password
    if @user.save
      send_welcome_email(@user.password)
      true
    else
      false
    end
  end

  private

  def random_password
    SecureRandom.uuid.split("-")[0]
  end

  def send_welcome_email(password)
    UserMailer.welcome_email(@user.id, password).deliver
  end
end

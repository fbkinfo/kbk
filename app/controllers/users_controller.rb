class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user, only: [:destroy, :update, :edit, :unlock]
  before_filter :check_permissions, except: :index

  respond_to :html

  def index
    @sorter = UsersSorter.new(params[:s])
    @users = @sorter.apply(User.all).page(params[:page])

    render layout: 'index'
  end

  def new
    @user = User.new
  end

  def unlock
    @user.unlock_access!
    redirect_to action: :index
  end

  def create
    @user = User.new(user_params)
    signup = Signup.new(@user)

    if signup.save
      redirect_to :users, notice: "Пользователю отправлено письмо с паролем"
    else
      render :new
    end
  end

  def update
    @user.update(user_params)

    respond_with @user, location: :users
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    user = params.require(:user)
    user = if current_user.admin?
      user.permit!
    else
      user.permit(:email, :password, :password_confirmation)
    end

    if user[:password].blank?
      user.delete("password")
      user.delete("password_confirmation")
    end
    user
  end

  def check_permissions
    unless current_user.admin? || @user == current_user
      redirect_to :root
    end
  end
end

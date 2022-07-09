class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login, :status_update]

  # REGISTER
  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { errors: "Invalid username or password" }
    end
  end

  # LOGGIN IN
  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      token = encode_token({ user: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: "Invalid username or password" }
    end
  end

  def auto_login
    render json: @user
  end

  def status_update
    @user.update(status: 1)
    render json: { message: "user status updated" }
  end

  private

  def user_params
    params.permit(:username, :password, :status)
  end
end

class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login, :check_in, :check_out]

  # REGISTER
  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, :status => :unauthorized
    end
  end

  # LOGGIN IN
  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      token = encode_token({ user: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { errors: @user.errors.full_messages }, :status => :unauthorized
    end
  end

  def auto_login
    render json: @user
  end

  def check_in
    @user.update(status: 1)
    render json: { user: @user, message: "user checked in" }
  end

  def check_out
    @user.update(status: 0)
    render json: { user: @user, message: "user checked out" }
  end

  private

  def user_params
    params.permit(:username, :password, :status)
  end
end

class UsersController < ApplicationController
  before_action :authorized, except: %i[create login]
  before_action :find_user, only: %i[show update login]

  # # GET /users
  # def index
  #   @users = User.all
  #   render json: @users, status: :ok
  # end

  # # GET /users/{username}
  # def show
  #   render json: @user, status: :ok
  # end

  # PUT /users/{username}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # REGISTER
  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # LOGGIN IN
  def login
    if @user && @user.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { errors: @user.errors.full_messages }, status: :unauthorized
    end
  end

  def auto_login
    render json: @user
  end

  def check_in
    if @user.status == "in"
      render json: { message: "user already checked in" }
    else
      @user.update(status: 1)
      render json: { user: @user, message: "user checked in" }
    end
  end

  def check_out
    if @user.status == "out"
      render json: { message: "user already checked out" }
    else
      @user.update(status: 0)
      render json: { user: @user, message: "user checked out" }
    end
  end

  private

  def user_params
    params.permit(:username, :password, :status)
  end

  def valid_username?(input)
    regex = Regexp.new("^AAA/A/01-00111/2019$", Regexp::IGNORECASE)
    regex.match input
  end

  def find_user
    @user = User.find_by_username!(params[:username])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "User not found" }, status: :not_found
  end
end

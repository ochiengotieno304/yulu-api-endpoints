class ApplicationController < ActionController::API
  before_action :authorized

  SECRET = Rails.application.credentials.secret_key_base

  def encode_token(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET)
  end

  def auth_header
    # { Authorization: 'bearer <token>' }
    request.headers["Authorization"]
  end

  def decoded_token
    if auth_header
      token = auth_header.split(" ")[1]
      # header: { Authorization: 'bearer <token>' }
      begin
        JWT.decode(token, SECRET, true, algorithm: "HS512")
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: "please log in" }, status: :unauthorized unless logged_in?
  end
end

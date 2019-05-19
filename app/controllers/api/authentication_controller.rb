class Api::AuthenticationController < ApplicationController
  before_action :require_admin, only: :login
  before_action :authorize_request, except: :login

  # POST api/auth/login
  def login
    if @admin&.authenticate(params[:password])
      render json: { token: generate_token, exp: exp_time, nickname: @admin.nickname }, status: :ok
    else
      render json: { error: 'Invalide email or password.' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def require_admin
    @admin = Admin.find_by_email(params[:email])
  end

  def generate_token
    JsonWebToken.encode(admin_id: @admin.id)
  end

  def exp_time
    time = Time.now + 24.hours.to_i
    time.strftime('%m-%d-%Y %H:%M')
  end
end

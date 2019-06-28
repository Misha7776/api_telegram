class ApplicationController < ActionController::API
  before_action :set_raven_context

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    @decoded = JsonWebToken.decode(jwt_token)
    @current_user = Admin.find(@decoded[:admin_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :unauthorized
  rescue JWT::DecodeError => e
    render json: { errors: e.message }, status: :unauthorized
  end

  private

  def jwt_token
    header = request.headers['Authorization']
    header&.split(' ')&.last
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end

class ApplicationController < ActionController::API
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
end

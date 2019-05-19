class Api::AdminsController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_admin, except: %i[create index]

  # GET /api/admins
  def index
    @admins = Admin.all
    render json: @admins, status: :ok
  end

  # GET /api/admins/:id
  def show
    render json: @admin, status: :ok
  end

  # POST /api/admins
  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      render json: @admin, status: :created
    else
      render json: { errors: @admin.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /api/admins/:id
  def update
    if @admin.update(admin_params)
      render json: { message: 'Attributes updated' }, status: :ok
    else
      render json: { errors: @admin.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /api/admins/:id
  def destroy
    render json: { message: 'User destroyed' }, status: :ok if @admin.destroy
  end

  private

  def find_admin
    @admin = Admin.find_by!(id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Admin with id #{params[:id]} not found" },
           status: :not_found
  end

  def admin_params
    params.permit(:name, :nickname, :email, :password, :password_confirmation)
  end
end

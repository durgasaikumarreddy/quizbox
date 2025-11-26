class AdminController < ApplicationController
  include JwtHelper

  # POST /admin/login
  # Expects params: { email: "  ", password: " " }
  # Returns JWT token if credentials are valid
  # Example response:
  # { token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." }
  def login
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      token = encode_token({ admin_id: admin.id })
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end

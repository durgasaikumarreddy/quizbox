module JwtHelper
  SECRET_KEY = Rails.application.secrets.secret_key.to_s

  # Encode a payload into a JWT token
  def encode_token(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decode a JWT token from the Authorization header
  def decode_token
    header = request.headers["Authorization"]
    return nil unless header

    token = header.split(" ").last
    JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
  rescue JWT::DecodeError
    nil
  end

  # Authorize admin based on the decoded JWT token
  def authorize_admin
    decoded = decode_token
    render json: { error: "Unauthorized" }, status: :unauthorized unless decoded && decoded["admin_id"]
  end
end

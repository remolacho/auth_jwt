require 'auth_jwt/version'
require 'auth_jwt/authorized_user'

module AuthJwt
  class << self
    mattr_accessor :secret_key_api,
                   :secret_key_jwt,
                   :algorithm,
                   :class_name_model,
                   :model_primary_key,
                   :payload_primary_key
  end

  def self.configure(&block)
    yield self
  end

  def authorized_user
    render json: { message: 'The user has not token active' }, status: 403 unless logged_in?
  rescue StandardError => e
    render json: { message: "The error was #{e.to_s}" }, status: 500
  end

  def authorized_app
    unless AuthJwt::secret_key_api.eql?(auth_client)
      render json: {message: 'The app has not access' }, status: 401
    end
  end

  def encode_token(payload)
    return  { message: 'The payload is not present'} unless payload.present?
    {jwt: JWT.encode(payload, AuthJwt::secret_key_jwt, AuthJwt::algorithm || 'HS256')}
  end

  private

  def logged_in?
    !!logged_in_user
  end

  def logged_in_user
    decode = decoded_token
    return unless decode

    default_field = 'id'
    field_payload = AuthJwt::payload_primary_key.presence || default_field
    field_model   = AuthJwt::model_primary_key.presence || default_field

    @current_user = if AuthJwt::class_name_model.present?
      AuthJwt::class_name_model.classify.constantize.find_by(field_model => decode[0][field_payload])
    else
      AuthJwt::AuthorizedUser.new(decode[0])
    end
  end

  def decoded_token
    return unless auth_jwt.present?
    token = auth_jwt.split(' ')[1]
    JWT.decode(token, AuthJwt::secret_key_jwt, true, { algorithm: AuthJwt::algorithm || 'HS256'} )
  rescue JWT::DecodeError
    nil
  end

  # { Authorization: 'Bearer <token>' }
  def auth_jwt
    request.headers['Authorization']
  end

  def auth_client
    request.headers['Api-Token']
  end

  def current_user
    @current_user
  end
end

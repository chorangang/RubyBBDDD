require 'bcrypt'
require 'jwt'
require './src/domain/models/token'
require './src/domain/models/user'
require './src/infrastructure/repository/token_repository'

class AuthService
  def initialize
    pp "===== auth_service ====="
  end

  # Passwordのハッシュ化
  def passwrod_hash(user)
    @user = user
    @user.set_password_value(BCrypt::Password.create(@user.password))
    @user
  end

  # Passwordの検証
  def verify(password, hashed_password)
    BCrypt::Password.create(hashed_password) == hashed_password
  end

  def generate_token(token)
    @token = token
    @token.value = JWT.encode {user_id: @token.user_id}, ENV['HMAC_SECRET'], 'HS256'

    @token
  end
end

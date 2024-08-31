require 'bcrypt'
require 'jwt'
require './src/modules/secrets_loader'
require './src/domain/models/token'
require './src/domain/models/user'
require './src/infrastructure/repository/token_repository'

class AuthService
  def initialize
    pp "===== auth_service ====="
    @token_repo = TokenRepository.new
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

    # Moduleで秘密鍵を取ってきてJWTを生成しTokenの中身を書き換える
    secrets = SecretsLoader.load

    payload = {
      user_id: @token.user_id,
      expired: @token.expired_at # 1時間後
    }

    @token.set_values(JWT.encode(payload, secrets.private_key, 'RS256'))

    @token
  end

  def token_exsits?(token)
    token = @token_repo.find(token)
    token.nil?
  end
end
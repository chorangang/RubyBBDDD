require 'time'
require 'jwt'
require './src/modules/secrets_loader'
require './src/infrastructure/repository/token_repository'

class TokenService
  def initialize
    pp "===== token_service ====="
    @repo = TokenRepository.new
  end

  def generate_token(token)
    # Moduleで秘密鍵を取ってきてJWTを生成しTokenの中身を書き換える
    secrets = SecretsLoader.load
    content = {
      user_id: token.user_id,
      expired: Time + 60 * 60 # 1時間後
    }
    token.value = JWT.encode(content, secrets.private_key, 'RS256')
    token
  end

  def exsits?(token)
    token = @repo.find(token)
    token.nil?
  end

  def save(token)
    @repo.save(token)
  end
end
require 'jwt'
require 'json'
require './src/modules/secrets_loader'
require './src/routes/routes'

class JwtAuthMiddleware
  def initialize(app)
    @app = app
    @skip_paths = SKIP_PATHS
    pp "=== skip_auth_paths ==="
    pp @skip_paths
  end

  def call(env)
    # 認証をスキップするパスかどうかを判定
    request = Rack::Request.new(env)
    path = request.path_info

    # 認証をスキップするパスの場合はそのまま次のミドルウェアまたはアプリケーションに処理を渡す
    if @skip_paths.include?(path)
      return @app.call(env)
    end

    # リクエストヘッダーからAuthorizationを取得
    authorization = env['HTTP_AUTHORIZATION']
    unless authorization
      return unauthorized_response
    end

    # Bearerトークンを取得
    bearer, token = authorization.split(' ')
    unless bearer == 'Bearer'
      return unauthorized_response
    end

    # JWTトークンを検証
    begin
      # Module:SecretsLoaderを利用して環境変数を読み込む
      secrets = SecretsLoader.load
      # JWTトークンを検証
      JWT.decode(token, secrets.private_key, 'RS256')
    rescue JWT::DecodeError
      return unauthorized_response
    end

    @app.call(env)
  end

  private

  def unauthorized_response
    return [401, { 'Content-Type' => 'application/json' }, [{ message: 'Unauthorized' }.to_json]]
  end
end
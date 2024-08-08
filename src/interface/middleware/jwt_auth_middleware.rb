require 'jwt'
require 'json'
require './src/modules/secrets_loader'
require './src/routes/routes'
require './src/application/usecase/auth_service'

class JwtAuthMiddleware
  def initialize(app)
    pp "===== jwt_auth_middleware ====="
    @app = app
    @skip_paths = SKIP_PATHS
    @auth_service = AuthService.new
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
      decoded = JWT.decode(token, secrets.private_key, 'RS256')
  
      # トークンの有効期限を確認
      if decoded.first['expired'] < Time.now.to_i
        return unauthorized_response(msg: 'Token expired')
      end

      # ブラックリストにないか確認
      if @auth_service.authenticate(token)
        return unauthorized_response(msg: 'Token revoked')
      end
    rescue JWT::DecodeError
      return unauthorized_response
    end

    @app.call(env)
  end


  private

  def unauthorized_response(msg: 'Unauthorized')
    jwt = env['HTTP_AUTHORIZATION']
    @auth_service.logout(jwt)
    return [401, { 'Content-Type' => 'application/json' }, [{ message: msg }.to_json]]
  end
end